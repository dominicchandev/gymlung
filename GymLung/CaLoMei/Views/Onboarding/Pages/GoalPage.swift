//
//  GoalPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct GoalPage: View {
    @Binding var selectedGoal: String
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.Goal.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.Goal.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: 40)

            VStack(spacing: 12) {
                ForEach(OnboardingQuestionData.goalOptions, id: \.title) { option in
                    SurveyOptionButton(
                        title: option.title,
                        subtitle: AppStrings.Goal.goalSubtitle(option.title, mode),
                        icon: option.icon,
                        isSelected: selectedGoal == option.title
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGoal = option.title
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onProceed()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}
