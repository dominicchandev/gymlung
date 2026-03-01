//
//  MealTimesSheet.swift
//  CaLoMei
//

import SwiftUI

struct MealTimesSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue

    @State private var breakfastTime: Date
    @State private var lunchTime: Date
    @State private var dinnerTime: Date

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    init() {
        let defaults = UserDefaults.standard
        let cal = Calendar.current

        let defaultBreakfast = cal.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
        let defaultLunch = cal.date(from: DateComponents(hour: 12, minute: 30)) ?? Date()
        let defaultDinner = cal.date(from: DateComponents(hour: 19, minute: 0)) ?? Date()

        let bInterval = defaults.double(forKey: "breakfastTime")
        let lInterval = defaults.double(forKey: "lunchTime")
        let dInterval = defaults.double(forKey: "dinnerTime")

        _breakfastTime = State(initialValue: bInterval > 0 ? Date(timeIntervalSince1970: bInterval) : defaultBreakfast)
        _lunchTime = State(initialValue: lInterval > 0 ? Date(timeIntervalSince1970: lInterval) : defaultLunch)
        _dinnerTime = State(initialValue: dInterval > 0 ? Date(timeIntervalSince1970: dInterval) : defaultDinner)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text(AppStrings.MealTimes.title(mode))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

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

                    Text(AppStrings.MealTimes.notificationHint(mode))
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)

                    Spacer()

                    ActionButton(title: AppStrings.Profile.saveButton(mode)) {
                        save()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
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
        }
    }

    private func save() {
        UserDefaults.standard.set(breakfastTime.timeIntervalSince1970, forKey: "breakfastTime")
        UserDefaults.standard.set(lunchTime.timeIntervalSince1970, forKey: "lunchTime")
        UserDefaults.standard.set(dinnerTime.timeIntervalSince1970, forKey: "dinnerTime")

        NotificationManager().scheduleMealReminders(
            breakfast: breakfastTime,
            lunch: lunchTime,
            dinner: dinnerTime
        )

        dismiss()
    }
}
