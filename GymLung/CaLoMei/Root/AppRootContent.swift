//
//  AppRootContent.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData

struct AppRootContent: View {
    @Environment(AppStateManager.self) var appStateManager
    @Environment(AuthManager.self) var authManager
    @AppStorage("colorTheme") private var colorTheme: String = ColorTheme.amber.rawValue
    @Query private var profiles: [UserProfile]

    @State private var splashFinished = false

    var body: some View {
        ZStack {
            Group {
                switch appStateManager.state {
                case .loading:
                    SplashScreenView()

                case .signIn:
                    SignInPage()

                case .onboarding:
                    OnboardingView()

                case .main:
                    MainTabView()
                }
            }
            .id(colorTheme)

            // Splash overlay that stays for 2s then fades out
            if !splashFinished {
                SplashScreenView()
                    .transition(.opacity)
                    .zIndex(1)
            }

            #if DEBUG
            DevPanelButton()
                .ignoresSafeArea()
                .zIndex(2)
            #endif
        }
        .task {
            await authManager.initialize()
            resolveState()

            // Ensure splash stays at least 2 seconds
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeOut(duration: 0.5)) {
                splashFinished = true
            }
        }
        .onChange(of: authManager.state) { _, _ in
            resolveState()
        }
    }

    private func resolveState() {
        let hasCompleted = profiles.first?.onboardingCompleted == true
        appStateManager.resolve(
            isAuthenticated: authManager.isAuthenticated,
            hasCompletedOnboarding: hasCompleted
        )
    }
}
