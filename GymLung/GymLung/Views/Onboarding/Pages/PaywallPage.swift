//
//  PaywallPage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import SwiftUI
import RevenueCat

struct PaywallPage: View {
    var onProceed: () -> Void  // called when user subscribes OR dismisses

    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    @State private var offerings: Offerings?
    @State private var selectedPackage: Package?
    @State private var isLoading = false
    @State private var isPurchasing = false

    private var annualPackage: Package? {
        offerings?.current?.annual
    }

    private var monthlyPackage: Package? {
        offerings?.current?.monthly
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Cancel button top-left, restore top-right
                HStack {
                    Button(action: { onProceed() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Theme.bgCard))
                    }
                    Spacer()

                    // Restore button top-right
                    Button(action: {
                        Task {
                            let manager = PurchaseManager.shared
                            let restored = await manager.restorePurchases()
                            if restored { onProceed() }
                        }
                    }) {
                        Text(AppStrings.Paywall.restore(mode))
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer().frame(height: 20)

                // Pro badge
                Text("PRO")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Theme.neonGreen))

                Spacer().frame(height: 16)

                // Title
                Text(AppStrings.Paywall.title(mode))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 8)

                Text(AppStrings.Paywall.subtitle(mode))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 32)

                // Feature list
                VStack(spacing: 16) {
                    PaywallFeatureRow(icon: "camera.fill", text: AppStrings.Paywall.feature1(mode))
                    PaywallFeatureRow(icon: "chart.bar.fill", text: AppStrings.Paywall.feature2(mode))
                    PaywallFeatureRow(icon: "bell.fill", text: AppStrings.Paywall.feature3(mode))
                    PaywallFeatureRow(icon: "flame.fill", text: AppStrings.Paywall.feature4(mode))
                }
                .padding(.horizontal, 32)

                Spacer()

                // Package selection
                if let monthly = monthlyPackage, let annual = annualPackage {
                    VStack(spacing: 12) {
                        // Annual option (highlighted)
                        PackageOptionCard(
                            package: annual,
                            label: AppStrings.Paywall.annualLabel(mode),
                            priceLabel: annual.localizedPriceString + "/年",
                            badge: AppStrings.Paywall.saveBadge(mode),
                            isSelected: selectedPackage?.identifier == annual.identifier,
                            onTap: { selectedPackage = annual }
                        )

                        // Monthly option
                        PackageOptionCard(
                            package: monthly,
                            label: AppStrings.Paywall.monthlyLabel(mode),
                            priceLabel: monthly.localizedPriceString + "/月",
                            badge: nil,
                            isSelected: selectedPackage?.identifier == monthly.identifier,
                            onTap: { selectedPackage = monthly }
                        )
                    }
                    .padding(.horizontal, 24)
                } else if isLoading {
                    ProgressView()
                        .tint(Theme.neonGreen)
                        .padding()
                }

                Spacer().frame(height: 20)

                // Subscribe button
                ActionButton(
                    title: isPurchasing ? "處理中..." : AppStrings.Paywall.cta(mode),
                    disabled: selectedPackage == nil || isPurchasing
                ) {
                    guard let pkg = selectedPackage else { return }
                    isPurchasing = true
                    Task {
                        let success = await PurchaseManager.shared.purchase(pkg)
                        isPurchasing = false
                        if success { onProceed() }
                    }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 32)
            }
        }
        .task {
            isLoading = true
            do {
                offerings = try await Purchases.shared.offerings()
                // Default select annual
                selectedPackage = annualPackage
            } catch {
                print("Error loading offerings: \(error)")
            }
            isLoading = false
        }
    }
}

// MARK: - Feature Row

struct PaywallFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Theme.neonGreen)
                .frame(width: 28)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white)

            Spacer()
        }
    }
}

// MARK: - Package Option Card

struct PackageOptionCard: View {
    let package: Package
    let label: String
    let priceLabel: String
    let badge: String?
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(label)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)

                        if let badge {
                            Text(badge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Theme.neonGreen))
                        }
                    }

                    Text(priceLabel)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                // Radio indicator
                Circle()
                    .strokeBorder(isSelected ? Theme.neonGreen : Theme.border, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Theme.neonGreen : Color.clear))
                    .frame(width: 22, height: 22)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.bgCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Theme.neonGreen : Theme.border, lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
