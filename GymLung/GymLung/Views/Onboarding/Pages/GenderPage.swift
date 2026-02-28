//
//  GenderPage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct GenderPage: View {
    @Binding var selectedGender: String
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            // Title
            VStack(spacing: 8) {
                Text(AppStrings.Gender.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.Gender.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 40)

            // Options
            VStack(spacing: 12) {
                ForEach(OnboardingQuestionData.genderOptions, id: \.title) { option in
                    SurveyOptionButton(
                        title: option.title,
                        icon: option.icon,
                        isSelected: selectedGender == option.title
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGender = option.title
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
