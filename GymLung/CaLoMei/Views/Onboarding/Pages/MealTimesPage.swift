//
//  MealTimesPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI

struct MealTimesPage: View {
    @Binding var breakfastTime: Date
    @Binding var lunchTime: Date
    @Binding var dinnerTime: Date
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.MealTimes.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.MealTimes.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 40)

            // Three meal time pickers in cards
            VStack(spacing: 16) {
                MealTimeRow(
                    icon: "sunrise.fill",
                    label: AppStrings.MealTimes.breakfastLabel(mode),
                    time: $breakfastTime
                )

                MealTimeRow(
                    icon: "sun.max.fill",
                    label: AppStrings.MealTimes.lunchLabel(mode),
                    time: $lunchTime
                )

                MealTimeRow(
                    icon: "moon.fill",
                    label: AppStrings.MealTimes.dinnerLabel(mode),
                    time: $dinnerTime
                )
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 16)

            Text(AppStrings.MealTimes.notificationHint(mode))
                .font(.system(size: 13))
                .foregroundColor(Theme.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            ActionButton(title: "繼續") {
                onProceed()
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 40)
        }
    }
}

struct MealTimeRow: View {
    let icon: String
    let label: String
    @Binding var time: Date

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Theme.neonGreen)
                .frame(width: 32)

            Text(label)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .tint(Theme.neonGreen)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.bgCard)
        )
    }
}
