//
//  FoodEntryCard.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI

struct FoodEntryCard: View {
    let entry: FoodEntry
    var onRetry: (() -> Void)? = nil

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

    private var isScanning: Bool { entry.scanStatus == "scanning" }
    private var isFailed: Bool { entry.scanStatus == "failed" }

    var body: some View {
        HStack(spacing: 0) {
            // Photo (if available)
            if hasPhoto, let data = entry.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0
                        )
                    )
                    .overlay {
                        if isScanning {
                            // Dim overlay on photo while scanning
                            Color.black.opacity(0.3)
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 16,
                                        bottomLeadingRadius: 16,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 0
                                    )
                                )
                        }
                    }
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                if isScanning {
                    scanningContent
                } else if isFailed {
                    failedContent
                } else {
                    normalContent
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgElevated)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Scanning State

    private var scanningContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("掃描中...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textPrimary)

            HStack(spacing: 8) {
                ProgressView()
                    .tint(Theme.neonGreen)
                Text("AI 分析緊...")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer().frame(height: 0)
        }
    }

    // MARK: - Failed State

    private var failedContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("掃描失敗")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.neonRed)

            if let onRetry {
                Button {
                    onRetry()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 13, weight: .semibold))
                        Text("重試")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(Theme.neonGreen)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.neonGreen, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Normal State (completed scan)

    private var normalContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name + Time
            HStack(alignment: .top) {
                Text(entry.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(1)

                Spacer()

                Text(timeString)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }

            // Component breakdown (multi-component only)
            if entry.isMultiComponent {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(entry.components.prefix(3), id: \.id) { comp in
                        HStack(spacing: 4) {
                            Text(comp.nameZH)
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text("\(comp.calories) kcal")
                                .font(.system(size: 12).monospacedDigit())
                                .foregroundColor(Theme.textTertiary)
                        }
                    }
                    if entry.components.count > 3 {
                        Text("+\(entry.components.count - 3) 項")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textTertiary)
                    }
                }
            }

            // Calories
            HStack(spacing: 6) {
                Text("🔥")
                    .font(.system(size: 18))
                Text("\(entry.calories) 卡路里")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }

            // Macros row
            HStack(spacing: 16) {
                macroLabel(emoji: "🍗", value: "\(Int(entry.proteinG))g")
                macroLabel(emoji: "🌾", value: "\(Int(entry.carbsG))g")
                macroLabel(emoji: "🫐", value: "\(Int(entry.fatG))g")
            }
        }
    }

    private func macroLabel(emoji: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.textSecondary)
        }
    }
}
