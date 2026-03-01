//
//  AgePage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct AgePage: View {
    @Binding var birthday: Date
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    private var age: Int {
        Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 25
    }

    /// Earliest selectable date (~80 years ago)
    private var earliestDate: Date {
        Calendar.current.date(byAdding: .year, value: -80, to: Date()) ?? Date()
    }

    /// Latest selectable date (~15 years ago, minimum age)
    private var latestDate: Date {
        Calendar.current.date(byAdding: .year, value: -15, to: Date()) ?? Date()
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)

            VStack(spacing: 8) {
                Text(AppStrings.Age.title(mode))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(AppStrings.Age.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 50)

            // Age display computed from birthday
            VStack(spacing: 16) {
                Text("\(age)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(Theme.neonGreen)
                    .contentTransition(.numericText())

                Text("歲")
                    .font(.system(size: 20))
                    .foregroundColor(Theme.textSecondary)

                DatePicker(
                    "生日",
                    selection: $birthday,
                    in: earliestDate...latestDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "zh_HK"))
                .frame(height: 150)
                .clipped()
            }

            Spacer()

            ActionButton(title: "繼續") {
                onProceed()
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 40)
        }
    }
}
