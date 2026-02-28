//
//  StreakCelebrationSheet.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI

struct StreakCelebrationDialog: View {
    let day: Int
    var onDismiss: () -> Void = {}

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    private var isMajorMilestone: Bool {
        [30, 60, 90, 180, 365].contains(day)
    }

    // MARK: - Animation State

    @State private var currentPage = 1

    // Page 1: fire animation
    @State private var fireOpacity: Double = 0
    @State private var fireScale: CGFloat = 0.6
    @State private var glowOpacity: Double = 0

    // Page 2: content
    @State private var contentOpacity: Double = 0

    var body: some View {
        ZStack {
            // Dim background — tap to dismiss
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            if currentPage == 1 {
                page1FireAnimation
            } else {
                page2Content
                    .opacity(contentOpacity)
                    .transition(.opacity)
            }
        }
        .onAppear {
            runFireAnimation()
        }
    }

    // MARK: - Page 1: Fire Animation

    private var page1FireAnimation: some View {
        ZStack {
            // Glow behind fire
            Circle()
                .fill(Theme.neonGreen.opacity(0.3))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .opacity(glowOpacity)

            Text("🔥")
                .font(.system(size: 80))
                .scaleEffect(fireScale)
                .opacity(fireOpacity)
        }
    }

    // MARK: - Page 2: Streak Info

    private var page2Content: some View {
        VStack(spacing: 16) {
            // Fire + streak count
            Text("🔥")
                .font(.system(size: 56))

            Text("\(day)")
                .font(.system(size: 56, weight: .black).monospacedDigit())
                .foregroundColor(Theme.neonGreen)
                .neonGlow(Theme.neonGreen, radius: 12)

            Text(dayLabel)
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)

            // Feedback message
            VStack(spacing: 10) {
                if isMajorMilestone {
                    Text(AppStrings.Streak.milestoneTitle(day: day, mode))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(AppStrings.Streak.milestoneBody(day: day, mode))
                        .font(.system(size: 15))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text(AppStrings.Streak.dailyMessage(day: day, mode))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.bgCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.neonGreen.opacity(0.3), lineWidth: 1)
                )
        )
        .neonGlow(Theme.neonGreen, radius: 16)
        .padding(.horizontal, 32)
        .onTapGesture { dismiss() }
    }

    // MARK: - Animation Sequence

    private func runFireAnimation() {
        let initialDelay: Double = 0.3
        let scaleUpDuration: Double = 0.4
        let settleDuration: Double = 0.15
        let glowDelay: Double = 0.25
        let glowDuration: Double = 0.3
        let pageSwitchDelay: Double = 0.5

        func cubic(_ duration: Double) -> Animation {
            .timingCurve(0.25, 1.87, 0.59, 0.98, duration: duration)
        }

        // Step 1: Fire appears and scales up 0.6 → 1.4
        withAnimation(cubic(scaleUpDuration).delay(initialDelay)) {
            fireOpacity = 1.0
            fireScale = 1.4
        }

        // Step 2: Fire settles 1.4 → 1.3
        let settleStart = initialDelay + scaleUpDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + settleStart) {
            withAnimation(.easeIn(duration: settleDuration)) {
                fireScale = 1.3
            }
        }

        // Step 3: Glow appears
        let glowStart = settleStart + glowDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + glowStart) {
            withAnimation(.easeInOut(duration: glowDuration)) {
                glowOpacity = 1.0
            }
        }

        // Step 4: Switch to page 2
        let totalDelay = glowStart + glowDuration + pageSwitchDelay
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            withAnimation(.easeInOut(duration: 0.35)) {
                currentPage = 2
            }
            withAnimation(.easeInOut(duration: 0.4).delay(0.1)) {
                contentOpacity = 1.0
            }
        }

        // Step 5: Auto-dismiss after 4 seconds on page 2
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay + 4) {
            dismiss()
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.25)) {
            onDismiss()
        }
    }

    private var dayLabel: String {
        if isMajorMilestone {
            return "日 streak"
        }
        return "日連續記錄"
    }
}
