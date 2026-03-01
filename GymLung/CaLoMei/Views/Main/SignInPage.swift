//
//  SignInPage.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import AuthenticationServices
import SwiftData

struct SignInPage: View {
    @Environment(AuthManager.self) var authManager
    @Environment(AppStateManager.self) var appStateManager
    @Query private var profiles: [UserProfile]

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @State private var showContent = false

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo area
                VStack(spacing: 20) {
                    Image("AppLogo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Theme.neonGreen)
                        .frame(width: 100, height: 100)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)

                    VStack(spacing: 8) {
                        Text("CaLoMei")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)

                        Text(AppStrings.SignIn.tagline(mode))
                            .font(.system(size: 16))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 15)
                }

                Spacer()

                // Features
                VStack(spacing: 16) {
                    FeatureRow(icon: "camera.fill", text: AppStrings.SignIn.feature1(mode))
                    FeatureRow(icon: "chart.bar.fill", text: AppStrings.SignIn.feature2(mode))
                    FeatureRow(icon: "fork.knife", text: AppStrings.SignIn.feature3(mode))
                }
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)

                Spacer()

                // Sign in buttons
                VStack(spacing: 16) {
                    // Apple Sign In button (custom styled, matching Rise pattern)
                    AppleSignInButton(
                        onSuccess: {
                            let hasCompleted = profiles.first?.onboardingCompleted == true
                            withAnimation {
                                appStateManager.resolve(
                                    isAuthenticated: true,
                                    hasCompletedOnboarding: hasCompleted
                                )
                            }
                        }
                    )
                    .padding(.horizontal, 24)

                    Text(AppStrings.SignIn.skipButton(mode))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Theme.textTertiary)

                    if authManager.state == .loading {
                        ProgressView()
                            .tint(.white)
                    }

                    if let error = authManager.error {
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.neonRed)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
                .opacity(showContent ? 1 : 0)

                Spacer().frame(height: 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
}

// MARK: - Apple Sign In Button (Rise pattern)

private struct AppleSignInButton: View {
    @Environment(AuthManager.self) private var authManager

    let onSuccess: () -> Void

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

            authManager.signInWithApple(
                successCallback: {
                    onSuccess()
                }
            )
        }) {
            HStack(spacing: 12) {
                Spacer()
                Image(systemName: "apple.logo")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                Text("用 Apple 登入")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.bgCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(authManager.state == .loading)
    }
}

// MARK: - Feature Row

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Theme.neonGreen)
                .frame(width: 28)

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(Theme.textSecondary)

            Spacer()
        }
    }
}
