//
//  WeightLogSheet.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI
import SwiftData

struct WeightLogSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \WeightEntry.date, order: .forward) private var weightEntries: [WeightEntry]
    @Query private var profiles: [UserProfile]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue

    @State private var weightKG: Double = 65
    @State private var initialized = false
    @State private var roastText: String?

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }
    private var profile: UserProfile? { profiles.first }
    private var lastEntry: WeightEntry? { weightEntries.last }

    private var diff: Double? {
        guard let last = lastEntry else { return nil }
        return weightKG - last.weightKG
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    WeightWheelPicker(value: $weightKG)

                    // Diff display
                    if let diff, abs(diff) > 0.01 {
                        HStack(spacing: 6) {
                            Text(AppStrings.Progress.vsLast(mode))
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textTertiary)

                            let isLoss = diff < 0
                            HStack(spacing: 2) {
                                Image(systemName: isLoss ? "arrow.down" : "arrow.up")
                                    .font(.system(size: 11, weight: .bold))
                                Text(String(format: "%.1f kg", abs(diff)))
                                    .font(.system(size: 14, weight: .semibold).monospacedDigit())
                            }
                            .foregroundColor(isLoss ? Theme.neonGreen : Theme.neonRed)
                        }
                    }

                    Spacer()

                    // Save button
                    ActionButton(title: AppStrings.Progress.logButton(mode)) {
                        saveWeight()
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 20)
                }
            }
            .navigationTitle(AppStrings.Progress.logTitle(mode))
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
                guard !initialized else { return }
                initialized = true
                if let last = lastEntry {
                    weightKG = last.weightKG
                } else if let p = profile {
                    weightKG = p.weightKG
                }
            }
            .overlay {
                if let roast = roastText {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Text(mode.roastEmoji)
                                .font(.system(size: 48))

                            Text(roast)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Theme.neonAmber.opacity(0.7), lineWidth: 1)
                                )
                        )
                        .neonGlow(Theme.neonAmber, radius: 16)
                        .padding(.horizontal, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }

    private func saveWeight() {
        // Capture diff BEFORE modifying data (computed property reads live SwiftData)
        let previousWeight = lastEntry?.weightKG
        let d: Double? = previousWeight.map { weightKG - $0 }

        // One entry per day: update existing or insert new
        let today = Calendar.current.startOfDay(for: Date())
        if let existing = weightEntries.last(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            existing.weightKG = weightKG
        } else {
            let entry = WeightEntry(weightKG: weightKG)
            modelContext.insert(entry)
        }

        // Sync profile weight
        if let profile {
            profile.weightKG = weightKG
        }

        // Show goal-aware roast using captured diff
        let goal = profile?.goal ?? "維持體重"
        let roast: String
        if let d, abs(d) > 0.01 {
            if d < 0 {
                roast = AppStrings.Progress.weightLost(abs(d), goal: goal, mode)
            } else {
                roast = AppStrings.Progress.weightGained(d, goal: goal, mode)
            }
        } else {
            roast = AppStrings.Progress.weightSame(goal: goal, mode)
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            roastText = roast
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            dismiss()
        }
    }
}
