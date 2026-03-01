//
//  ActivityLevelPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct ActivityLevelPage: View {
    @Binding var selectedLevel: String
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.ActivityLevel.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.ActivityLevel.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 40)

            VStack(spacing: 12) {
                ForEach(OnboardingQuestionData.activityLevels, id: \.title) { option in
                    SurveyOptionButton(
                        title: option.title,
                        subtitle: AppStrings.ActivityLevel.levelSubtitle(option.title, mode),
                        icon: option.icon,
                        isSelected: selectedLevel == option.title
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedLevel = option.title
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
