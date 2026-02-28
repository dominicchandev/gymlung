//
//  OnboardingView.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData
import UserNotifications

struct OnboardingView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(AppStateManager.self) var appStateManager
    @Environment(AuthManager.self) var authManager
    @Environment(DataSyncManager.self) var dataSyncManager

    @State var currentPage: OnboardingPage = .welcome
    @State var onboardingStates = OnboardingUserStates()
    @State var direction: Edge = .trailing

    private let pages: [OnboardingPage] = OnboardingPage.allCases

    private var currentIndex: Int {
        pages.firstIndex(of: currentPage) ?? 0
    }

    private var progress: Double {
        Double(currentIndex) / Double(pages.count - 1)
    }

    func goToNext() {
        let nextIndex = currentIndex + 1
        if nextIndex < pages.count {
            direction = .trailing
            withAnimation(.easeInOut(duration: 0.35)) {
                currentPage = pages[nextIndex]
            }
        }
    }

    func goBack() {
        let prevIndex = currentIndex - 1
        if prevIndex >= 0 {
            direction = .leading
            withAnimation(.easeInOut(duration: 0.35)) {
                currentPage = pages[prevIndex]
            }
        }
    }

    func handleMealTimesComplete() {
        // Save times to UserDefaults
        UserDefaults.standard.set(onboardingStates.breakfastTime.timeIntervalSince1970, forKey: "breakfastTime")
        UserDefaults.standard.set(onboardingStates.lunchTime.timeIntervalSince1970, forKey: "lunchTime")
        UserDefaults.standard.set(onboardingStates.dinnerTime.timeIntervalSince1970, forKey: "dinnerTime")

        // Request notification permission then proceed
        Task {
            let center = UNUserNotificationCenter.current()
            let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted == true {
                let manager = NotificationManager()
                manager.scheduleMealReminders(
                    breakfast: onboardingStates.breakfastTime,
                    lunch: onboardingStates.lunchTime,
                    dinner: onboardingStates.dinnerTime
                )
            }
            await MainActor.run {
                goToNext()
            }
        }
    }

    func completeOnboarding() {
        // Phase 1: Synchronous — insert local profile
        let profile = UserProfile(
            name: onboardingStates.name,
            gender: onboardingStates.gender,
            age: onboardingStates.age,
            heightCM: onboardingStates.heightCM,
            weightKG: onboardingStates.weightKG,
            targetWeightKG: onboardingStates.targetWeightKG,
            activityLevel: onboardingStates.activityLevel,
            goal: onboardingStates.goal,
            dailyCalorieTarget: onboardingStates.recommendedCalories,
            proteinTargetG: onboardingStates.recommendedProtein,
            carbsTargetG: onboardingStates.recommendedCarbs,
            fatTargetG: onboardingStates.recommendedFat,
            onboardingCompleted: true
        )
        modelContext.insert(profile)

        withAnimation(.easeInOut(duration: 0.5)) {
            appStateManager.state = .main
        }

        // Phase 3: Background — sync profile to Supabase
        if let userId = authManager.userId {
            let syncManager = dataSyncManager
            Task(priority: .utility) {
                await syncManager.upsertProfile(profile, userId: userId)
            }
        }
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                if currentPage != .welcome && currentPage != .paywall {
                    HStack(spacing: 12) {
                        Button(action: goBack) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                        }

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Theme.bgDivider)
                                    .frame(height: 6)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Theme.neonGreen)
                                    .frame(width: geometry.size.width * progress, height: 6)
                                    .animation(.easeInOut(duration: 0.3), value: progress)
                            }
                        }
                        .frame(height: 6)

                        ToneToggleButton()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                }

                // Page content
                Group {
                    switch currentPage {
                    case .welcome:
                        WelcomePage(
                            name: $onboardingStates.name,
                            onProceed: goToNext
                        )
                    case .gender:
                        GenderPage(
                            selectedGender: $onboardingStates.gender,
                            onProceed: goToNext
                        )
                    case .age:
                        AgePage(
                            birthday: $onboardingStates.birthday,
                            onProceed: goToNext
                        )
                    case .heightWeight:
                        HeightWeightPage(
                            heightCM: $onboardingStates.heightCM,
                            weightKG: $onboardingStates.weightKG,
                            onProceed: goToNext
                        )
                    case .activityLevel:
                        ActivityLevelPage(
                            selectedLevel: $onboardingStates.activityLevel,
                            onProceed: goToNext
                        )
                    case .goal:
                        GoalPage(
                            selectedGoal: $onboardingStates.goal,
                            onProceed: goToNext
                        )
                    case .targetWeight:
                        TargetWeightPage(
                            currentWeight: onboardingStates.weightKG,
                            targetWeight: $onboardingStates.targetWeightKG,
                            goal: onboardingStates.goal,
                            onProceed: goToNext
                        )
                    case .mealTimes:
                        MealTimesPage(
                            breakfastTime: $onboardingStates.breakfastTime,
                            lunchTime: $onboardingStates.lunchTime,
                            dinnerTime: $onboardingStates.dinnerTime,
                            onProceed: handleMealTimesComplete
                        )
                    case .paywall:
                        PaywallPage(onProceed: goToNext)
                    case .summary:
                        OnboardingSummaryPage(
                            states: onboardingStates,
                            onComplete: completeOnboarding
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: direction == .trailing ? .trailing : .leading),
                    removal: .move(edge: direction == .trailing ? .leading : .trailing)
                ))
            }
        }
    }
}
