//
//  ActionButton.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    var bgColor: Color = Theme.neonGreen
    var textColor: Color = Color(hex: "#111111")
    var height: CGFloat = 54
    var fontSize: CGFloat = 18
    var disabled: Bool = false
    var action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            if disabled { return }
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(disabled ? .gray : textColor)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(disabled ? Theme.border : bgColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            disabled ? Theme.textMuted : bgColor.opacity(0.6),
                            lineWidth: 2
                        )
                )
                .neonGlow(disabled ? .clear : bgColor, radius: 12)
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}
