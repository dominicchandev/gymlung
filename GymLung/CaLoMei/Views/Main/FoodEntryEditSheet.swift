//
//  FoodEntryEditSheet.swift
//  CaLoMei
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
    @State private var componentEdits: [ComponentEdit]

    private enum NutritionField: Hashable {
        case calories, protein, carbs, fat
        case componentCal(UUID)
        case componentProtein(UUID)
        case componentCarbs(UUID)
        case componentFat(UUID)
    }

    struct ComponentEdit: Identifiable {
        let id: UUID
        var nameZH: String
        var calories: String
        var protein: String
        var carbs: String
        var fat: String
        var portionDescription: String
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
        _componentEdits = State(initialValue: entry.components.map { comp in
            ComponentEdit(
                id: comp.id,
                nameZH: comp.nameZH,
                calories: "\(comp.calories)",
                protein: "\(Int(comp.proteinG))",
                carbs: "\(Int(comp.carbsG))",
                fat: "\(Int(comp.fatG))",
                portionDescription: comp.portionDescription
            )
        })
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
            navBar
                .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.name)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)

                        Text(timeString)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal, 20)

                    editableContent
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 80)
                }
                .padding(.top, 16)
            }

            saveButton
        }
    }

    // MARK: - Photo Layout

    private var photoLayout: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                if let data = entry.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 320)
                        .clipped()
                }

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

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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

                    editableContent
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

    // MARK: - Editable Content

    @ViewBuilder
    private var editableContent: some View {
        if entry.isMultiComponent && !componentEdits.isEmpty {
            // Multi-component: show each component separately
            VStack(spacing: 16) {
                // Aggregate totals header
                aggregateTotalsCard

                // Individual components
                ForEach($componentEdits) { $comp in
                    componentSection(comp: $comp)
                }
            }
        } else {
            // Single entry: original nutrition cards
            nutritionSection
        }
    }

    // MARK: - Aggregate Totals (Multi-Component)

    private var aggregateTotalsCard: some View {
        let totalCal = componentEdits.reduce(0) { $0 + (Int($1.calories) ?? 0) }
        let totalP = componentEdits.reduce(0) { $0 + (Int($1.protein) ?? 0) }
        let totalC = componentEdits.reduce(0) { $0 + (Int($1.carbs) ?? 0) }
        let totalF = componentEdits.reduce(0) { $0 + (Int($1.fat) ?? 0) }

        return VStack(spacing: 8) {
            Text("總計")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("🔥 \(totalCal)")
                        .font(.system(size: 20, weight: .bold).monospacedDigit())
                        .foregroundColor(.white)
                    Text("kcal")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textTertiary)
                }
                Spacer()
                miniMacro(emoji: "🍗", value: totalP, unit: "g")
                miniMacro(emoji: "🌾", value: totalC, unit: "g")
                miniMacro(emoji: "🫐", value: totalF, unit: "g")
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.bgElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.neonGreen.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func miniMacro(emoji: String, value: Int, unit: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Text(emoji)
                    .font(.system(size: 12))
                Text("\(value)")
                    .font(.system(size: 15, weight: .bold).monospacedDigit())
                    .foregroundColor(.white)
            }
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(Theme.textTertiary)
        }
    }

    // MARK: - Component Section

    private func componentSection(comp: Binding<ComponentEdit>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Component name + portion
            HStack {
                Text(comp.wrappedValue.nameZH)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text(comp.wrappedValue.portionDescription)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textTertiary)
            }

            // Nutrition cards for this component
            let compId = comp.wrappedValue.id
            VStack(spacing: 8) {
                nutritionCard(
                    emoji: "🔥",
                    label: "卡路里",
                    value: comp.calories,
                    field: .componentCal(compId),
                    unit: "kcal"
                )

                HStack(spacing: 8) {
                    nutritionCard(
                        emoji: "🍗",
                        label: "蛋白質",
                        value: comp.protein,
                        field: .componentProtein(compId),
                        unit: "g"
                    )
                    nutritionCard(
                        emoji: "🌾",
                        label: "碳水",
                        value: comp.carbs,
                        field: .componentCarbs(compId),
                        unit: "g"
                    )
                    nutritionCard(
                        emoji: "🫐",
                        label: "脂肪",
                        value: comp.fat,
                        field: .componentFat(compId),
                        unit: "g"
                    )
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.bgCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.bgDivider, lineWidth: 1)
                )
        )
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

            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Nutrition Section (Single Entry)

    private var nutritionSection: some View {
        VStack(spacing: 12) {
            nutritionCard(
                emoji: "🔥",
                label: "卡路里",
                value: $calories,
                field: .calories,
                unit: "kcal"
            )

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
        let isCalories = {
            switch field {
            case .calories, .componentCal: return true
            default: return false
            }
        }()

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
                        .font(.system(size: isCalories ? 32 : 22, weight: .bold).monospacedDigit())
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.leading)
                        .fixedSize()
                } else {
                    Text(value.wrappedValue)
                        .font(.system(size: isCalories ? 32 : 22, weight: .bold).monospacedDigit())
                        .foregroundColor(.white)
                }

                if !isCalories {
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
        if entry.isMultiComponent && !componentEdits.isEmpty {
            // Recompute from component edits
            var updatedComponents = entry.components
            for edit in componentEdits {
                if let idx = updatedComponents.firstIndex(where: { $0.id == edit.id }) {
                    updatedComponents[idx].calories = Int(edit.calories) ?? updatedComponents[idx].calories
                    updatedComponents[idx].proteinG = Double(Int(edit.protein) ?? Int(updatedComponents[idx].proteinG))
                    updatedComponents[idx].carbsG = Double(Int(edit.carbs) ?? Int(updatedComponents[idx].carbsG))
                    updatedComponents[idx].fatG = Double(Int(edit.fat) ?? Int(updatedComponents[idx].fatG))
                }
            }
            entry.components = updatedComponents

            // Recompute aggregated totals
            entry.calories = updatedComponents.reduce(0) { $0 + $1.calories }
            entry.proteinG = updatedComponents.reduce(0) { $0 + $1.proteinG }
            entry.carbsG = updatedComponents.reduce(0) { $0 + $1.carbsG }
            entry.fatG = updatedComponents.reduce(0) { $0 + $1.fatG }
        } else {
            // Single entry: use direct values
            entry.calories = Int(calories) ?? entry.calories
            entry.proteinG = Double(Int(protein) ?? Int(entry.proteinG))
            entry.carbsG = Double(Int(carbs) ?? Int(entry.carbsG))
            entry.fatG = Double(Int(fat) ?? Int(entry.fatG))
        }
        dismiss()
    }
}
