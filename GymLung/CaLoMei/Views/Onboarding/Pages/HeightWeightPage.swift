//
//  HeightWeightPage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct HeightWeightPage: View {
    @Binding var heightCM: Double
    @Binding var weightKG: Double
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.HeightWeight.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.HeightWeight.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 40)

            VStack(spacing: 32) {
                // Height
                VStack(spacing: 12) {
                    HStack {
                        Text("身高")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Int(heightCM)) cm")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.neonGreen)
                    }

                    Slider(value: $heightCM, in: 140...210, step: 1)
                        .tint(Theme.neonGreen)

                    HStack {
                        Text("140 cm")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textTertiary)
                        Spacer()
                        Text("210 cm")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
                .padding(.horizontal, 24)

                // Weight
                VStack(spacing: 8) {
                    Text("體重")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    WeightWheelPicker(value: $weightKG)
                }
                .padding(.horizontal, 24)

                // BMI display
                let bmi = weightKG / ((heightCM / 100) * (heightCM / 100))
                VStack(spacing: 4) {
                    Text("你嘅 BMI")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    Text(String(format: "%.1f", bmi))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Theme.bmiColor(bmi))
                    Text(bmiCategory(bmi))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.bmiColor(bmi))
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.bgCard)
                )
                .padding(.horizontal, 24)
            }

            Spacer()

            ActionButton(title: "繼續") {
                onProceed()
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 40)
        }
    }

    private func bmiCategory(_ bmi: Double) -> String {
        AppStrings.HeightWeight.bmiCategory(bmi, mode)
    }
}
