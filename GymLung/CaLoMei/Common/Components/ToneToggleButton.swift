//
//  ToneToggleButton.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI

struct ToneToggleButton: View {
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        Button {
            let allModes = ToneMode.allCases
            let currentIndex = allModes.firstIndex(of: mode) ?? 0
            let nextIndex = (currentIndex + 1) % allModes.count
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.easeInOut(duration: 0.2)) {
                toneModeRaw = allModes[nextIndex].rawValue
            }
        } label: {
            Text(mode.roastEmoji)
                .font(.system(size: 16))
                .frame(width: 40, height: 40)
                .background(Circle().fill(Theme.bgCard))
                .overlay(Circle().stroke(Theme.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
