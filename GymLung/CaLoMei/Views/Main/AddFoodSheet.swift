//
//  AddFoodSheet.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData

struct AddFoodSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @State private var searchText = ""
    @State private var showCustomEntry = false
    @State private var roastText: String?

    // USDA search state
    @State private var usdaResults: [USDAFoodResult] = []
    @State private var isSearchingUSDA = false
    @State private var usdaSearchFailed = false
    @State private var searchTask: Task<Void, Never>?

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    // Custom entry fields
    @State private var customName = ""
    @State private var customCalories = ""
    @State private var customProtein = ""
    @State private var customCarbs = ""
    @State private var customFat = ""
    @State private var customServing = "1份"

    private var filteredFoods: [(name: String, calories: Int, protein: Double, carbs: Double, fat: Double, meal: String)] {
        if searchText.isEmpty {
            return OnboardingQuestionData.sampleFoods
        }
        return OnboardingQuestionData.sampleFoods.filter { $0.name.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textTertiary)
                            TextField("", text: $searchText, prompt: Text(AppStrings.AddFood.searchPlaceholder(mode)).foregroundColor(Theme.textTertiary))
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Theme.bgCard)
                        )
                        .padding(.horizontal, 20)

                        // Custom entry toggle
                        Button(action: {
                            withAnimation { showCustomEntry.toggle() }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Theme.neonGreen)
                                Text(AppStrings.AddFood.customToggle(mode))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Theme.neonGreen)
                                Spacer()
                                Image(systemName: showCustomEntry ? "chevron.up" : "chevron.down")
                                    .foregroundColor(Theme.textTertiary)
                            }
                            .padding(.horizontal, 20)
                        }

                        // Custom entry form
                        if showCustomEntry {
                            VStack(spacing: 12) {
                                CustomInputField(label: AppStrings.AddFood.foodNameLabel(mode), text: $customName, placeholder: "例如：雞胸肉飯")
                                CustomInputField(label: "卡路里 (kcal)", text: $customCalories, placeholder: "0", isNumber: true)

                                HStack(spacing: 12) {
                                    CustomInputField(label: "蛋白質 (g)", text: $customProtein, placeholder: "0", isNumber: true)
                                    CustomInputField(label: "碳水 (g)", text: $customCarbs, placeholder: "0", isNumber: true)
                                    CustomInputField(label: "脂肪 (g)", text: $customFat, placeholder: "0", isNumber: true)
                                }

                                CustomInputField(label: "份量", text: $customServing, placeholder: "1份")

                                ActionButton(
                                    title: AppStrings.AddFood.submit(mode),
                                    disabled: customName.isEmpty || customCalories.isEmpty
                                ) {
                                    addCustomFood()
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.bgCard)
                            )
                            .padding(.horizontal, 20)
                        }

                        // Local HK foods section
                        VStack(spacing: 0) {
                            HStack {
                                Text(AppStrings.AddFood.foodsHeader(mode))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)

                            ForEach(filteredFoods, id: \.name) { food in
                                Button(action: {
                                    addFood(food)
                                }) {
                                    foodRow(name: food.name, calories: food.calories, protein: food.protein, carbs: food.carbs, fat: food.fat)
                                }

                                Divider()
                                    .background(Theme.bgDivider)
                                    .padding(.horizontal, 20)
                            }
                        }

                        // USDA loading / results section
                        if !searchText.isEmpty {
                            if isSearchingUSDA {
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .tint(Theme.neonGreen)
                                    Text(AppStrings.AddFood.searchLoading(mode))
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textTertiary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                            } else if usdaSearchFailed && usdaResults.isEmpty {
                                Text(AppStrings.AddFood.noResults(mode))
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.textTertiary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }

                            if !usdaResults.isEmpty {
                                VStack(spacing: 0) {
                                    ForEach(usdaResults) { food in
                                        Button(action: {
                                            addUSDAFood(food)
                                        }) {
                                            foodRow(name: food.name.localizedCapitalized, calories: food.calories, protein: food.proteinG, carbs: food.carbsG, fat: food.fatG)
                                        }

                                        Divider()
                                            .background(Theme.bgDivider)
                                            .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }

                        Spacer().frame(height: 20)
                    }
                    .padding(.top, 16)
                }
            }
            .navigationTitle(AppStrings.AddFood.navTitle(mode))
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
            .onChange(of: searchText) { _, newValue in
                searchTask?.cancel()
                usdaSearchFailed = false

                guard !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    usdaResults = []
                    isSearchingUSDA = false
                    return
                }

                isSearchingUSDA = true
                searchTask = Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(500))
                    guard !Task.isCancelled else { return }

                    do {
                        let results = try await USDAFoodService.shared.search(query: newValue)
                        guard !Task.isCancelled else { return }
                        usdaResults = results
                        usdaSearchFailed = results.isEmpty
                    } catch is CancellationError {
                        // user typed more — ignore
                    } catch {
                        guard !Task.isCancelled else { return }
                        usdaResults = []
                        usdaSearchFailed = true
                    }
                    isSearchingUSDA = false
                }
            }
            .onDisappear {
                searchTask?.cancel()
            }
            .overlay {
                if let roast = roastText {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Text(mode.roastEmoji)
                                .font(.system(size: 48))

                            Text(roast)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Theme.neonAmber.opacity(0.7), lineWidth: 1)
                                )
                        )
                        .neonGlow(Theme.neonAmber, radius: 16)
                        .padding(.horizontal, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }

    // MARK: - Shared Food Row

    @ViewBuilder
    private func foodRow(name: String, calories: Int, protein: Double, carbs: Double, fat: Double) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("蛋白 \(Int(protein))g · 碳水 \(Int(carbs))g · 脂肪 \(Int(fat))g")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textTertiary)
            }
            Spacer()
            Text("\(calories) kcal")
                .font(.system(size: 14, weight: .semibold).monospacedDigit())
                .foregroundColor(Theme.neonGreen)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Actions

    private func addFood(_ food: (name: String, calories: Int, protein: Double, carbs: Double, fat: Double, meal: String)) {
        let entry = FoodEntry(
            name: food.name,
            calories: food.calories,
            proteinG: food.protein,
            carbsG: food.carbs,
            fatG: food.fat
        )
        modelContext.insert(entry)
        showRoast(for: food.name)
    }

    private func addUSDAFood(_ food: USDAFoodResult) {
        let entry = FoodEntry(
            name: food.name.localizedCapitalized,
            calories: food.calories,
            proteinG: food.proteinG,
            carbsG: food.carbsG,
            fatG: food.fatG,
            servingSize: "100g"
        )
        modelContext.insert(entry)
        showRoast(for: food.name)
    }

    private func addCustomFood() {
        let entry = FoodEntry(
            name: customName,
            calories: Int(customCalories) ?? 0,
            proteinG: Double(customProtein) ?? 0,
            carbsG: Double(customCarbs) ?? 0,
            fatG: Double(customFat) ?? 0,
            servingSize: customServing
        )
        modelContext.insert(entry)
        showRoast(for: customName)
    }

    private func showRoast(for foodName: String) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            roastText = FoodRoasts.roast(for: foodName, mode: mode)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            dismiss()
        }
    }
}

// MARK: - Custom Input Field

private struct CustomInputField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isNumber: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(Theme.textMuted))
                .font(.system(size: 15))
                .foregroundColor(.white)
                .keyboardType(isNumber ? .decimalPad : .default)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.bgElevated)
                )
        }
    }
}
