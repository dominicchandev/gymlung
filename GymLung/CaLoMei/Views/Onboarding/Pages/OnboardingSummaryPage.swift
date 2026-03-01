//
//  OnboardingSummaryPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct OnboardingSummaryPage: View {
    let states: OnboardingUserStates
    var onComplete: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @State private var showContent = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 20)

                // Header
                VStack(spacing: 8) {
                    Text(AppStrings.Summary.title(mode))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(AppStrings.Summary.description(states.name, states.goal, mode))
                        .font(.system(size: 15))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)

                // Calorie target card
                VStack(spacing: 16) {
                    Text(AppStrings.Summary.calorieLabel(states.goal, mode))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)

                    Text("\(states.recommendedCalories)")
                        .font(.system(size: 56, weight: .bold).monospacedDigit())
                        .foregroundColor(Theme.neonGreen)

                    Text("千卡 (kcal)")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.bgCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.neonGreen.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)

                // Macro breakdown
                VStack(spacing: 16) {
                    Text(AppStrings.Summary.macroHeader(mode))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        MacroCard(
                            title: "蛋白質",
                            value: String(format: "%.0fg", states.recommendedProtein),
                            color: Theme.macroProtein,
                            icon: "🥩"
                        )
                        MacroCard(
                            title: "碳水",
                            value: String(format: "%.0fg", states.recommendedCarbs),
                            color: Theme.macroCarbs,
                            icon: "🍚"
                        )
                        MacroCard(
                            title: "脂肪",
                            value: String(format: "%.0fg", states.recommendedFat),
                            color: Theme.macroFat,
                            icon: "🥑"
                        )
                    }
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)

                // Profile summary
                VStack(spacing: 12) {
                    SummaryRow(label: "目標", value: states.goal, icon: "🎯")
                    SummaryRow(label: "運動量", value: states.activityLevel, icon: "🏃🏻")
                    SummaryRow(label: "身高", value: "\(Int(states.heightCM)) cm", icon: "📏")
                    SummaryRow(label: "體重", value: String(format: "%.1f kg", states.weightKG), icon: "⚖️")
                    if states.goal != "維持體重" {
                        SummaryRow(label: "目標體重", value: String(format: "%.1f kg", states.targetWeightKG), icon: "🏆")
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.bgCard)
                )
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)

                // CTA
                ActionButton(title: AppStrings.Summary.cta(mode)) {
                    onComplete()
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)

                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Supporting Views

private struct MacroCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 24))

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(color)

            Text(title)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.bgCard)
        )
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Text(icon)
                .font(.system(size: 18))
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}
