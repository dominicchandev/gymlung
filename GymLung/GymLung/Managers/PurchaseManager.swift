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
        Purchases.configure(withAPIKey: "appl_qmJYEErUSnEcfgBYepUldFgLaZT")
    }

    @MainActor
    func loadOfferings() async {
        isLoading = true
        do {
            offerings = try await Purchases.shared.offerings()
        } catch {
            print("Error loading offerings: \(error)")
        }
        isLoading = false
    }

    @MainActor
    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            isPro = customerInfo.entitlements["pro"]?.isActive == true
        } catch {
            print("Error checking entitlement: \(error)")
        }
    }

    @MainActor
    func purchase(_ package: Package) async -> Bool {
        do {
            let result = try await Purchases.shared.purchase(package: package)
            isPro = result.customerInfo.entitlements["pro"]?.isActive == true
            return isPro
        } catch {
            print("Error purchasing: \(error)")
            return false
        }
    }

    @MainActor
    func restorePurchases() async -> Bool {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            isPro = customerInfo.entitlements["pro"]?.isActive == true
            return isPro
        } catch {
            print("Error restoring: \(error)")
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

    var canScan: Bool {
        if isPro { return true }
        resetIfNewDay()
        return dailyScanCount < 2
    }

    var remainingScans: Int {
        if isPro { return .max }
        resetIfNewDay()
        return max(0, 2 - dailyScanCount)
    }

    func recordScan() {
        resetIfNewDay()
        dailyScanCount += 1
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
