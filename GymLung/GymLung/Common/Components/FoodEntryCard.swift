//
//  FoodEntryCard.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI

struct FoodEntryCard: View {
    let entry: FoodEntry

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
            }

            // Content
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
            .padding(16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgElevated)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
