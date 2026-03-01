//
//  FoodLogPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData

struct FoodLogPage: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodEntry.createdAt, order: .reverse) private var allEntries: [FoodEntry]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @State private var showAddFood = false
    @State private var selectedDate = Date()

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    private var entriesForDate: [FoodEntry] {
        let calendar = Calendar.current
        return allEntries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var totalDayCalories: Int {
        entriesForDate.reduce(0) { $0 + $1.calories }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Date selector
                    HStack(spacing: 16) {
                        Button(action: {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }

                        Text(dateDisplayString())
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Button(action: {
                            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                            if tomorrow <= Date() {
                                selectedDate = tomorrow
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(Calendar.current.isDateInToday(selectedDate) ? Theme.textMuted : .white)
                        }
                        .disabled(Calendar.current.isDateInToday(selectedDate))
                    }
                    .padding(.vertical, 12)

                    // Total for the day
                    HStack {
                        Text(AppStrings.FoodLog.total(mode))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                        Text("\(totalDayCalories) kcal")
                            .font(.system(size: 18, weight: .bold).monospacedDigit())
                            .foregroundColor(Theme.neonGreen)
                    }
                    .padding(.horizontal, 20)

                    // Food entries
                    if entriesForDate.isEmpty {
                        HStack {
                            Text(AppStrings.FoodLog.empty(mode))
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textTertiary)
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.bgCard)
                        )
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(entriesForDate) { entry in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(entry.name)
                                            .font(.system(size: 15))
                                            .foregroundColor(.white)
                                        Text(entry.servingSize)
                                            .font(.system(size: 12))
                                            .foregroundColor(Theme.textTertiary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(entry.calories) kcal")
                                            .font(.system(size: 14, weight: .medium).monospacedDigit())
                                            .foregroundColor(.white)
                                        Text("蛋白 \(Int(entry.proteinG))g")
                                            .font(.system(size: 11))
                                            .foregroundColor(Theme.textTertiary)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        modelContext.delete(entry)
                                    } label: {
                                        Label("刪除", systemImage: "trash")
                                    }
                                }

                                if entry.id != entriesForDate.last?.id {
                                    Divider()
                                        .background(Theme.bgDivider)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.bgCard)
                        )
                        .padding(.horizontal, 20)
                    }

                    // Add button
                    ActionButton(title: AppStrings.FoodLog.addButton(mode)) {
                        showAddFood = true
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    Spacer().frame(height: 20)
                }
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle(AppStrings.FoodLog.navTitle(mode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showAddFood) {
                AddFoodSheet()
            }
        }
    }

    private func dateDisplayString() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            return "今日"
        } else if calendar.isDateInYesterday(selectedDate) {
            return "尋日"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_HK")
            formatter.dateFormat = "M月d日"
            return formatter.string(from: selectedDate)
        }
    }
}

