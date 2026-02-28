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

    var body: some View {
        Group {
            switch appStateManager.state {
            case .loading:
                ZStack {
                    Theme.bg.ignoresSafeArea()
                    ProgressView()
                        .tint(.white)
                }

            case .signIn:
                SignInPage()

            case .onboarding:
                OnboardingView()

            case .main:
                MainTabView()
            }
        }
        .id(colorTheme)
        .task {
            // Restore session on launch (like Rise's initialize pattern)
            await authManager.initialize()
            resolveState()
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
