//
//  FoodScanResultSheet.swift
//  CaLoMei
//
//  Created by Claude on 28/2/2026.
//

import SwiftUI
import SwiftData

struct FoodScanResultSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @AppStorage("region") private var regionRaw: String = Region.deviceDefault.rawValue

    let capturedImage: UIImage

    @State private var scanner = FoodScannerManager()
    @State private var isScanning = false
    @State private var errorMessage: String?
    @State private var editableItems: [EditableFoodItem] = []
    @State private var roastComment: String = ""
    @State private var showRoastToast = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }
    private var region: Region { Region(rawValue: regionRaw) ?? .hk }

    // Editable wrapper around scan results
    struct EditableFoodItem: Identifiable {
        let id: UUID
        var nameZH: String
        var nameEN: String
        var calories: String
        var protein: String
        var carbs: String
        var fat: String
        var portionDescription: String
        var confidence: Double
        var isIncluded: Bool

        init(from item: ScannedFoodItem) {
            self.id = UUID()
            self.nameZH = item.name_zh
            self.nameEN = item.name_en
            self.calories = "\(item.estimated_calories)"
            self.protein = "\(Int(item.protein_g))"
            self.carbs = "\(Int(item.carbs_g))"
            self.fat = "\(Int(item.fat_g))"
            self.portionDescription = item.portion_description
            self.confidence = item.confidence
            self.isIncluded = true
        }
    }

    private var includedItems: [EditableFoodItem] {
        editableItems.filter(\.isIncluded)
    }

    private var totalCalories: Int {
        includedItems.reduce(0) { $0 + (Int($1.calories) ?? 0) }
    }

    private var totalProtein: Int {
        includedItems.reduce(0) { $0 + (Int($1.protein) ?? 0) }
    }

    private var totalCarbs: Int {
        includedItems.reduce(0) { $0 + (Int($1.carbs) ?? 0) }
    }

    private var totalFat: Int {
        includedItems.reduce(0) { $0 + (Int($1.fat) ?? 0) }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Photo
                        Image(uiImage: capturedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 260)
                            .clipped()

                        // Content
                        VStack(spacing: 16) {
                            if isScanning {
                                loadingView
                            } else if let error = errorMessage {
                                errorView(error)
                            } else if !editableItems.isEmpty {
                                resultContent
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                .background(Theme.bg.ignoresSafeArea())

                // Save button
                if !editableItems.isEmpty && !isScanning {
                    saveButton
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Theme.bgCard))
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .overlay {
                if showRoastToast && !roastComment.isEmpty {
                    roastToastOverlay
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                        .zIndex(10)
                }
            }
            .task {
                await startScan()
            }
        }
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(Theme.neonGreen)
                .scaleEffect(1.5)

            Text("AI 分析緊...")
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text("😵")
                .font(.system(size: 40))
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(Theme.neonRed)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Button {
                Task { await startScan() }
            } label: {
                Text("再試")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.neonGreen)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.neonGreen, lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 24)
    }

    // MARK: - Result Content

    private var resultContent: some View {
        VStack(spacing: 16) {
            // Total calories
            VStack(spacing: 4) {
                Text("\(totalCalories)")
                    .font(.system(size: 42, weight: .bold).monospacedDigit())
                    .foregroundColor(Theme.neonGreen)
                    .contentTransition(.numericText())
                Text("kcal 總卡路里")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)

            // Total macros row
            HStack(spacing: 20) {
                macroSummary(emoji: "🍗", value: totalProtein, label: "蛋白質")
                macroSummary(emoji: "🌾", value: totalCarbs, label: "碳水")
                macroSummary(emoji: "🫐", value: totalFat, label: "脂肪")
            }
            .padding(.horizontal, 20)

            Divider()
                .background(Theme.bgDivider)
                .padding(.horizontal, 20)

            // Food items
            ForEach($editableItems) { $item in
                foodItemRow(item: $item)
                    .padding(.horizontal, 20)
            }
        }
    }

    private func macroSummary(emoji: String, value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 14))
                Text("\(value)g")
                    .font(.system(size: 16, weight: .bold).monospacedDigit())
                    .foregroundColor(.white)
            }
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.textSecondary)
        }
    }

    // MARK: - Food Item Row

    private func foodItemRow(item: Binding<EditableFoodItem>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header: name + toggle
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.wrappedValue.nameZH)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(item.wrappedValue.isIncluded ? .white : Theme.textMuted)
                        .strikethrough(!item.wrappedValue.isIncluded)

                    Text(item.wrappedValue.nameEN)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textTertiary)
                }

                Spacer()

                // Toggle include/exclude
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        item.wrappedValue.isIncluded.toggle()
                    }
                } label: {
                    Image(systemName: item.wrappedValue.isIncluded ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(item.wrappedValue.isIncluded ? Theme.neonGreen : Theme.textMuted)
                }
            }

            if item.wrappedValue.isIncluded {
                // Portion
                Text(item.wrappedValue.portionDescription)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)

                // Editable macros
                HStack(spacing: 8) {
                    inlineEdit(label: "🔥", value: item.calories, unit: "kcal")
                    inlineEdit(label: "🍗", value: item.protein, unit: "g")
                    inlineEdit(label: "🌾", value: item.carbs, unit: "g")
                    inlineEdit(label: "🫐", value: item.fat, unit: "g")
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(item.wrappedValue.isIncluded ? Theme.bgCard : Theme.bgCard.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.bgDivider, lineWidth: 1)
                )
        )
    }

    private func inlineEdit(label: String, value: Binding<String>, unit: String) -> some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.system(size: 12))
            TextField("0", text: value)
                .font(.system(size: 14, weight: .semibold).monospacedDigit())
                .foregroundColor(.white)
                .keyboardType(.numberPad)
                .fixedSize()
                .frame(minWidth: 24)
            Text(unit)
                .font(.system(size: 10))
                .foregroundColor(Theme.textTertiary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Theme.bg)
        )
    }

    // MARK: - Roast Toast

    private var roastToastOverlay: some View {
        VStack {
            Spacer()

            VStack(spacing: 8) {
                Text(mode.roastEmoji)
                    .font(.system(size: 28))
                Text(roastComment)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Theme.neonGreen)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.bgCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.neonGreen.opacity(0.4), lineWidth: 1)
                    )
            )
            .neonGlow(Theme.neonGreen, radius: 16)
            .padding(.horizontal, 40)
            .padding(.bottom, 120)
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        ActionButton(title: "認罪") {
            saveEntry()
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

    // MARK: - Actions

    private func startScan() async {
        guard let imageData = capturedImage.jpegData(compressionQuality: 0.8) else { return }
        isScanning = true
        errorMessage = nil

        do {
            let result = try await scanner.scan(imageData: imageData, toneMode: mode, region: region)
            editableItems = result.food_items.map { EditableFoodItem(from: $0) }
            roastComment = result.roast_comment

            // Show roast toast
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                showRoastToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { showRoastToast = false }
            }
        } catch {
            errorMessage = "掃描失敗：\(error.localizedDescription)"
        }

        isScanning = false
    }

    private func saveEntry() {
        let items = includedItems
        guard !items.isEmpty else { return }

        // Build name from included items
        let name = items.map(\.nameZH).joined(separator: " + ")

        // Build components
        let components: [FoodComponent] = items.map { item in
            FoodComponent(
                nameZH: item.nameZH,
                nameEN: item.nameEN,
                calories: Int(item.calories) ?? 0,
                proteinG: Double(Int(item.protein) ?? 0),
                carbsG: Double(Int(item.carbs) ?? 0),
                fatG: Double(Int(item.fat) ?? 0),
                portionDescription: item.portionDescription,
                confidence: item.confidence
            )
        }

        let entry = FoodEntry(
            name: name,
            calories: totalCalories,
            proteinG: Double(totalProtein),
            carbsG: Double(totalCarbs),
            fatG: Double(totalFat),
            servingSize: items.count == 1 ? items[0].portionDescription : "\(items.count)項",
            date: Date(),
            imageData: capturedImage.jpegData(compressionQuality: 0.7),
            components: components
        )

        modelContext.insert(entry)
        dismiss()
    }
}
