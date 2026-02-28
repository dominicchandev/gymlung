//
//  SurveyOptionButton.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct SurveyOptionButton: View {
    let title: String
    var subtitle: String? = nil
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Text(icon)
                        .font(.system(size: 28))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()

                Circle()
                    .fill(isSelected ? Theme.neonGreen : Color.clear)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Theme.neonGreen : Theme.textMuted, lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(isSelected ? Color(hex: "#111111") : .white)
                            .opacity(isSelected ? 1 : 0)
                    )
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Theme.selectedOptionBg : Theme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.neonGreen : Theme.border, lineWidth: 1.5)
            )
            .neonGlow(isSelected ? Theme.neonGreen : .clear, radius: 10)
        }
        .buttonStyle(.plain)
    }
}
