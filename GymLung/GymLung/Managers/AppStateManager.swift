//
//  AppStateManager.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation

enum AppState {
    case loading
    case signIn
    case onboarding
    case main
}

@Observable
class AppStateManager {
    var state: AppState = .loading

    func resolve(isAuthenticated: Bool, hasCompletedOnboarding: Bool) {
        if !isAuthenticated {
            state = .signIn
        } else if !hasCompletedOnboarding {
            state = .onboarding
        } else {
            state = .main
        }
    }
}
