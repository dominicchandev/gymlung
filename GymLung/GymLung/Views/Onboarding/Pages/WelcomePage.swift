//
//  WelcomePage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI

struct WelcomePage: View {
    @Binding var name: String
    var onProceed: () -> Void

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @FocusState private var isNameFocused: Bool
    @State private var showContent = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                // App icon / Logo area
                ZStack {
                    Circle()
                        .fill(Theme.neonGreen.opacity(0.15))
                        .frame(width: 120, height: 120)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Theme.neonGreen)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                VStack(spacing: 8) {
                    Text("GymLung")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text(AppStrings.Welcome.subtitle(mode))
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 15)
            }

            Spacer()

            // Name input
            VStack(spacing: 16) {
                Text(AppStrings.Welcome.nameQuestion(mode))
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                TextField("", text: $name, prompt: Text(AppStrings.Welcome.namePlaceholder(mode)).foregroundColor(Theme.textTertiary))
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.bgCard)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isNameFocused ? Theme.neonGreen : Theme.border, lineWidth: 1.5)
                    )
                    .focused($isNameFocused)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1 : 0)

            Spacer().frame(height: 40)

            // Continue button
            ActionButton(
                title: "繼續",
                disabled: name.trimmingCharacters(in: .whitespaces).isEmpty
            ) {
                isNameFocused = false
                onProceed()
            }
            .padding(.horizontal, 24)
            .opacity(showContent ? 1 : 0)

            Spacer().frame(height: 40)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}
