//
//  BodyInfoSheet.swift
//  GymLung
//

import SwiftUI
import SwiftData

struct BodyInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(AuthManager.self) var authManager
    @Environment(DataSyncManager.self) var dataSyncManager
    @Query private var profiles: [UserProfile]
    @Query(sort: \WeightEntry.date, order: .forward) private var weightEntries: [WeightEntry]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue

    @State private var gender: String = ""
    @State private var age: Int = 25
    @State private var heightCM: Double = 170
    @State private var weightKG: Double = 65
    @State private var targetWeightKG: Double = 60
    @State private var activityLevel: String = ""
    @State private var goal: String = ""
    @State private var initialized = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }
    private var profile: UserProfile? { profiles.first }

    private let activityLevels = ["好少運動", "輕度運動", "中等運動", "高強度運動"]
    private let goals = ["減脂", "維持體重", "增肌"]

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Gender
                        sectionLabel("性別")
                        HStack(spacing: 12) {
                            genderButton("男")
                            genderButton("女")
                        }
                        .padding(.horizontal, 20)

                        // Age
                        sectionLabel("年齡")
                        HStack {
                            Text("\(age) 歲")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            HStack(spacing: 0) {
                                Button(action: { if age > 12 { age -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(Theme.neonGreen)
                                }
                                .buttonStyle(.plain)
                                Button(action: { if age < 100 { age += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(Theme.neonGreen)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Height
                        sectionLabel("身高")
                        VStack(spacing: 8) {
                            Text("\(Int(heightCM)) cm")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            Slider(value: $heightCM, in: 140...210, step: 1)
                                .tint(Theme.neonGreen)
                        }
                        .padding(.horizontal, 20)

                        // Weight
                        sectionLabel("體重")
                        WeightWheelPicker(value: $weightKG)
                            .padding(.horizontal, 20)

                        // Goal
                        sectionLabel("目標")
                        VStack(spacing: 8) {
                            ForEach(goals, id: \.self) { g in
                                SurveyOptionButton(
                                    title: g,
                                    subtitle: AppStrings.Goal.goalSubtitle(g, mode),
                                    isSelected: goal == g
                                ) {
                                    goal = g
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // Target weight (if not maintaining)
                        if goal != "維持體重" {
                            sectionLabel("目標體重")
                            WeightWheelPicker(
                                value: $targetWeightKG,
                                range: goal == "減脂"
                                    ? 35...max(35, Int(weightKG) - 1)
                                    : goal == "增肌"
                                        ? min(150, Int(weightKG) + 1)...150
                                        : 35...150
                            )
                            .padding(.horizontal, 20)
                        }

                        // Activity level
                        sectionLabel("運動量")
                        VStack(spacing: 8) {
                            ForEach(activityLevels, id: \.self) { level in
                                SurveyOptionButton(
                                    title: level,
                                    subtitle: AppStrings.ActivityLevel.levelSubtitle(level, mode),
                                    isSelected: activityLevel == level
                                ) {
                                    activityLevel = level
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // Save
                        ActionButton(title: AppStrings.Profile.saveButton(mode)) {
                            save()
                        }
                        .padding(.horizontal, 20)

                        Spacer().frame(height: 20)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(AppStrings.AddFood.cancel(mode)) {
                        dismiss()
                    }
                    .foregroundColor(Theme.neonGreen)
                }
            }
            .onAppear {
                guard !initialized, let p = profile else { return }
                gender = p.gender
                age = p.age
                heightCM = p.heightCM
                weightKG = p.weightKG
                targetWeightKG = p.targetWeightKG ?? p.weightKG
                activityLevel = p.activityLevel
                goal = p.goal
                initialized = true
            }
        }
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Theme.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }

    private func genderButton(_ g: String) -> some View {
        Button(action: { gender = g }) {
            Text(g)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(gender == g ? Theme.selectedOptionBg : Theme.bgCard)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(gender == g ? Theme.neonGreen : Theme.border, lineWidth: 1.5)
                )
                .neonGlow(gender == g ? Theme.neonGreen : .clear, radius: 10)
        }
        .buttonStyle(.plain)
    }

    private func save() {
        guard let profile = profile else { return }

        // Build OnboardingUserStates to recalculate macros
        var states = OnboardingUserStates()
        states.gender = gender
        states.heightCM = heightCM
        states.weightKG = weightKG
        states.targetWeightKG = targetWeightKG
        states.activityLevel = activityLevel
        states.goal = goal
        // Set birthday to match the age (approximate)
        states.birthday = Calendar.current.date(byAdding: .year, value: -age, to: Date()) ?? Date()

        // Update profile
        profile.gender = gender
        profile.age = age
        profile.heightCM = heightCM
        profile.weightKG = weightKG
        // Insert or update WeightEntry if weight actually changed
        let lastRecorded = weightEntries.last?.weightKG ?? 0
        if abs(weightKG - lastRecorded) > 0.01 {
            let today = Calendar.current.startOfDay(for: Date())
            if let existing = weightEntries.last(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
                existing.weightKG = weightKG
            } else {
                let entry = WeightEntry(weightKG: weightKG)
                modelContext.insert(entry)
            }
        }
        profile.targetWeightKG = goal == "維持體重" ? nil : targetWeightKG
        profile.activityLevel = activityLevel
        profile.goal = goal
        profile.dailyCalorieTarget = states.recommendedCalories
        profile.proteinTargetG = states.recommendedProtein
        profile.carbsTargetG = states.recommendedCarbs
        profile.fatTargetG = states.recommendedFat

        // Sync to Supabase in background
        if let userId = authManager.userId {
            let syncManager = dataSyncManager
            Task(priority: .utility) {
                await syncManager.upsertProfile(profile, userId: userId)
            }
        }

        dismiss()
    }
}
