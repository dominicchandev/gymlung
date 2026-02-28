//
//  AuthManager.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import AuthenticationServices
import Supabase

@MainActor
@Observable
class AuthManager: NSObject, ASAuthorizationControllerDelegate {

    enum AuthState: Equatable {
        case idle
        case loading
        case signedIn
        case signedOut
    }

    var state: AuthState = .idle
    var userId: UUID?
    var userEmail: String?
    var error: String?

    /// Callbacks for sign-in completion
    var signInSuccessCallback: (() -> Void)?
    var signInNameCallback: ((String?) -> Void)?

    override init() {
        super.init()
    }

    // MARK: - Session Management

    /// Restore existing session on app launch
    func initialize() async {
        state = .loading
        do {
            let session = try await SupabaseConfig.client.auth.session
            self.userId = session.user.id
            self.userEmail = session.user.email
            self.state = .signedIn
        } catch {
            self.state = .signedOut
        }
    }

    // MARK: - Apple Sign In

    func signInWithApple(
        successCallback: (() -> Void)? = nil,
        nameCallback: ((String?) -> Void)? = nil
    ) {
        self.signInSuccessCallback = successCallback
        self.signInNameCallback = nameCallback

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    // MARK: - ASAuthorizationControllerDelegate

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let identityTokenData = credential.identityToken,
                  let idTokenString = String(data: identityTokenData, encoding: .utf8) else {
                self.error = "無法取得 Apple 登入資料"
                self.state = .signedOut
                return
            }

            // Extract display name (only available on first sign-in)
            let displayName: String? = {
                guard let name = credential.fullName else { return nil }
                let given = name.givenName ?? ""
                let family = name.familyName ?? ""
                let combined = "\(given) \(family)".trimmingCharacters(in: .whitespaces)
                return combined.isEmpty ? nil : combined
            }()

            signInNameCallback?(displayName)
            signInNameCallback = nil

            let appleCredentialEmail = credential.email

            self.state = .loading

            do {
                // Sign in with Supabase using the Apple ID token (no nonce needed with PKCE)
                let session = try await SupabaseConfig.client.auth.signInWithIdToken(
                    credentials: OpenIDConnectCredentials(
                        provider: .apple,
                        idToken: idTokenString
                    )
                )

                self.userId = session.user.id
                self.userEmail = session.user.email ?? appleCredentialEmail
                self.state = .signedIn
                self.error = nil

                signInSuccessCallback?()
            } catch {
                self.error = "登入失敗：\(error.localizedDescription)"
                self.state = .signedOut
            }

            signInSuccessCallback = nil
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            // User cancelled or other error
            if (error as? ASAuthorizationError)?.code == .canceled {
                // User cancelled, don't show error
            } else {
                self.error = "Apple 登入失敗：\(error.localizedDescription)"
            }
            self.state = .signedOut
        }
    }

    // MARK: - Sign Out

    func signOut() async {
        do {
            try await SupabaseConfig.client.auth.signOut()
            self.userId = nil
            self.userEmail = nil
            self.state = .signedOut
        } catch {
            self.error = "登出失敗：\(error.localizedDescription)"
        }
    }

    /// Whether user is currently signed in
    var isAuthenticated: Bool {
        state == .signedIn
    }
}
