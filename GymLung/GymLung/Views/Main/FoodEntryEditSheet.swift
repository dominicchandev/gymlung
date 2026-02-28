//
//  FoodEntryEditSheet.swift
//  GymLung
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import SwiftUI

struct FoodEntryEditSheet: View {
    @Environment(\.dismiss) private var dismiss
    let entry: FoodEntry

    @State private var calories: String
    @State private var protein: String
    @State private var carbs: String
    @State private var fat: String

    @State private var editingField: NutritionField?

    private enum NutritionField: Hashable {
        case calories, protein, carbs, fat
    }

    private var hasPhoto: Bool {
        if let data = entry.imageData, !data.isEmpty {
            return true
        }
        return false
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: entry.createdAt)
    }

    init(entry: FoodEntry) {
        self.entry = entry
        _calories = State(initialValue: "\(entry.calories)")
        _protein = State(initialValue: "\(Int(entry.proteinG))")
        _carbs = State(initialValue: "\(Int(entry.carbsG))")
        _fat = State(initialValue: "\(Int(entry.fatG))")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if hasPhoto {
                photoLayout
            } else {
                noPhotoLayout
            }
        }
        .background(Theme.bg.ignoresSafeArea())
    }

    // MARK: - No Photo Layout

    private var noPhotoLayout: some View {
        VStack(spacing: 0) {
            // Nav bar
            navBar
                .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Food name + time
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.name)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text(timeString)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal, 20)

                    // Nutrition cards
                    nutritionSection
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 80)
                }
                .padding(.top, 16)
            }

            // Save button
            saveButton
        }
    }

    // MARK: - Photo Layout

    private var photoLayout: some View {
        VStack(spacing: 0) {
            // Image fills top
            ZStack(alignment: .topLeading) {
                if let data = entry.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .clipped()
                }

                // Back button overlay
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(.ultraThinMaterial))
                }
                .padding(.leading, 16)
                .padding(.top, 8)
            }

            // Bottom sheet content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Time pill + food name
                    VStack(alignment: .leading, spacing: 10) {
                        Text(timeString)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Theme.textSecondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Theme.bgDivider)
                            )

                        Text(entry.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)

                    // Nutrition cards
                    nutritionSection
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 80)
                }
                .padding(.top, 20)
            }
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 24,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 24
                )
                .fill(Theme.bg)
                .offset(y: -24)
            )
            .offset(y: -24)

            saveButton
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Theme.bgCard))
            }

            Spacer()

            Text("營養資料")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            // Invisible spacer for centering
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Nutrition Section

    private var nutritionSection: some View {
        VStack(spacing: 12) {
            // Calories card (full width)
            nutritionCard(
                emoji: "🔥",
                label: "卡路里",
                value: $calories,
                field: .calories,
                unit: "kcal"
            )

            // Macro cards row
            HStack(spacing: 10) {
                nutritionCard(
                    emoji: "🍗",
                    label: "蛋白質",
                    value: $protein,
                    field: .protein,
                    unit: "g"
                )
                nutritionCard(
                    emoji: "🌾",
                    label: "碳水",
                    value: $carbs,
                    field: .carbs,
                    unit: "g"
                )
                nutritionCard(
                    emoji: "🫐",
                    label: "脂肪",
                    value: $fat,
                    field: .fat,
                    unit: "g"
                )
            }
        }
    }

    private func nutritionCard(
        emoji: String,
        label: String,
        value: Binding<String>,
        field: NutritionField,
        unit: String
    ) -> some View {
        let isEditing = editingField == field

        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }

            HStack(spacing: 4) {
                if isEditing {
                    TextField("0", text: value)
                        .font(.system(size: field == .calories ? 32 : 22, weight: .bold).monospacedDigit())
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                } else {
                    Text(value.wrappedValue)
                        .font(.system(size: field == .calories ? 32 : 22, weight: .bold).monospacedDigit())
                        .foregroundColor(.white)
                }

                if field != .calories {
                    Text(unit)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textTertiary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.bgCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isEditing ? Theme.neonGreen : Theme.bgDivider, lineWidth: 1)
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            editingField = field
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        ActionButton(title: "儲存") {
            save()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background(
            LinearGradient(
                colors: [Theme.bg.opacity(0), Theme.bg],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
        )
    }

    private func save() {
        entry.calories = Int(calories) ?? entry.calories
        entry.proteinG = Double(Int(protein) ?? Int(entry.proteinG))
        entry.carbsG = Double(Int(carbs) ?? Int(entry.carbsG))
        entry.fatG = Double(Int(fat) ?? Int(entry.fatG))
        dismiss()
    }
}
