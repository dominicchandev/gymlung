//
//  PurchaseManager.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import Foundation
import SwiftUI
import RevenueCat

@Observable
class PurchaseManager {
    static let shared = PurchaseManager()

    var isPro = false
    var offerings: Offerings?
    var isLoading = false

    private init() {}

    static func configure() {
        debugPrint("[PurchaseManager] Configuring RevenueCat...")
        Purchases.configure(withAPIKey: "appl_HZBQiWBmYTwaUvaABRSqOzFrDPs")
        // RevenueCat test: test_IgPGBczixLststinGDKoPrjbNab
        debugPrint("[PurchaseManager] Configuration complete.")
    }

    @MainActor
    func loadOfferings() async {
        isLoading = true
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            debugPrint("[PurchaseManager] Error loading offerings: \(error)")
        }
        isLoading = false
    }

    @MainActor
    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            isPro = customerInfo.entitlements["GymLung Pro"]?.isActive == true
        } catch {
            debugPrint("[PurchaseManager] Error checking entitlement: \(error)")
        }
    }

    @MainActor
    func purchase(_ package: Package) async -> Bool {
        do {
            let result = try await Purchases.shared.purchase(package: package)
            let entitlement = result.customerInfo.entitlements["GymLung Pro"]
            isPro = entitlement?.isActive == true

            // Schedule trial reminder notification if purchase started a trial
            if isPro, entitlement?.periodType == .trial {
                NotificationManager.scheduleTrialReminder()
            }

            return isPro
        } catch {
            debugPrint("[PurchaseManager] Error purchasing: \(error)")
            return false
        }
    }

    @MainActor
    func restorePurchases() async -> Bool {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            isPro = customerInfo.entitlements["GymLung Pro"]?.isActive == true
            return isPro
        } catch {
            debugPrint("[PurchaseManager] Error restoring: \(error)")
            return false
        }
    }

    // MARK: - Daily Scan Tracking

    private let defaults = UserDefaults.standard
    private static let scanCountKey = "dailyScanCount"
    private static let scanDateKey = "lastScanDate"

    var dailyScanCount: Int {
        get { defaults.integer(forKey: Self.scanCountKey) }
        set { defaults.set(newValue, forKey: Self.scanCountKey) }
    }

    private var lastScanDate: String {
        get { defaults.string(forKey: Self.scanDateKey) ?? "" }
        set { defaults.set(newValue, forKey: Self.scanDateKey) }
    }

    static let dailyScanLimit = 3

    var canScan: Bool {
        if isPro { return true }
        resetIfNewDay()
        return dailyScanCount < Self.dailyScanLimit
    }

    var remainingScans: Int {
        if isPro { return .max }
        resetIfNewDay()
        return max(0, Self.dailyScanLimit - dailyScanCount)
    }

    func recordScan() {
        resetIfNewDay()
        dailyScanCount += 1
    }

    func resetDailyScans() {
        dailyScanCount = 0
    }

    private func resetIfNewDay() {
        let today = Self.todayString()
        if lastScanDate != today {
            dailyScanCount = 0
            lastScanDate = today
        }
    }

    private static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
