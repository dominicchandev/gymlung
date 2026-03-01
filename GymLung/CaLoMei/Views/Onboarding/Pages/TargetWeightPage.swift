//
//  TargetWeightPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct TargetWeightPage: View {
    let currentWeight: Double
    @Binding var targetWeight: Double
    let goal: String
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    private var pickerRange: ClosedRange<Int> {
        switch goal {
        case "減脂":
            return 35...max(35, Int(currentWeight) - 1)
        case "增肌":
            return min(150, Int(currentWeight) + 1)...150
        default:
            return 35...150
        }
    }

    private var weightDiff: Double {
        targetWeight - currentWeight
    }

    private var estimatedWeeks: Int {
        let diffKg = abs(weightDiff)
        // Assume ~0.5kg per week for healthy change
        return max(1, Int(ceil(diffKg / 0.5)))
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.TargetWeight.title(goal, mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(goal == "維持體重" ? AppStrings.TargetWeight.subtitleMaintain(mode) : AppStrings.TargetWeight.subtitle(goal, mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 40)

            VStack(spacing: 20) {
                WeightWheelPicker(value: $targetWeight, range: pickerRange)

                // Info card
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(AppStrings.TargetWeight.currentLabel(mode))
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textSecondary)
                            Text(String(format: "%.1f kg", currentWeight))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Image(systemName: "arrow.right")
                            .foregroundColor(Theme.neonGreen)

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text(AppStrings.TargetWeight.targetLabel(mode))
                                .font(.system(size: 13))
                                .foregroundColor(Theme.textSecondary)
                            Text(String(format: "%.1f kg", targetWeight))
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Theme.neonGreen)
                        }
                    }

                    Divider().background(Theme.border)

                    HStack {
                        Text(weightDiff >= 0 ? AppStrings.TargetWeight.gainLabel(mode) : AppStrings.TargetWeight.lossLabel(mode))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                        Text(String(format: "%.1f kg", abs(weightDiff)))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    if goal != "維持體重" {
                        HStack {
                            Text("預計幾耐")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text(AppStrings.TargetWeight.timeEstimate(estimatedWeeks, mode))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(16)
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
        .onAppear {
            // Clamp target weight to valid range when page appears
            // (e.g. user went back, changed goal, and returned)
            let range = pickerRange
            let minVal = Double(range.lowerBound)
            let maxVal = Double(range.upperBound) + 0.9
            if targetWeight < minVal || targetWeight > maxVal {
                switch goal {
                case "減脂":
                    targetWeight = max(minVal, currentWeight - 5)
                case "增肌":
                    targetWeight = min(maxVal, currentWeight + 5)
                default:
                    targetWeight = currentWeight
                }
            }
        }
    }
}
