//
//  PaywallSheet.swift
//  GymLung
//

import SwiftUI
import RevenueCat

struct PaywallSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("region") private var regionRaw: String = Region.hk.rawValue
    private var region: Region { Region(rawValue: regionRaw) ?? .hk }

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
                // Top bar
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Theme.bgCard))
                    }
                    Spacer()

                    // Restore button
                    Button(action: {
                        Task {
                            let restored = await PurchaseManager.shared.restorePurchases()
                            if restored { dismiss() }
                        }
                    }) {
                        Text(AppStrings.Paywall.restore(region))
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer().frame(height: 20)

                // Pro badge
                Text("PRO")
                    .font(.system(size: 14, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Theme.neonGreen))

                Spacer().frame(height: 16)

                Text(AppStrings.Paywall.title(region))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 8)

                Text(AppStrings.Paywall.subtitle(region))
                    .font(.system(size: 15))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 32)

                // Feature list
                VStack(spacing: 16) {
                    PaywallFeatureRow(icon: "camera.fill", text: AppStrings.Paywall.feature1(region))
                    PaywallFeatureRow(icon: "chart.bar.fill", text: AppStrings.Paywall.feature2(region))
                    PaywallFeatureRow(icon: "theatermasks.fill", text: AppStrings.Paywall.feature3(region))
                    PaywallFeatureRow(icon: "infinity", text: AppStrings.Paywall.feature4(region))
                }
                .padding(.horizontal, 32)

                Spacer()

                // Package selection
                if let monthly = monthlyPackage, let annual = annualPackage {
                    VStack(spacing: 12) {
                        PackageOptionCard(
                            package: annual,
                            label: AppStrings.Paywall.annualLabel(region),
                            priceLabel: annual.localizedPriceString + "/年",
                            subtitle: AppStrings.Paywall.annualSubtitle(region),
                            badge: AppStrings.Paywall.saveBadge(region),
                            isSelected: selectedPackage?.identifier == annual.identifier,
                            onTap: { selectedPackage = annual }
                        )
                        PackageOptionCard(
                            package: monthly,
                            label: AppStrings.Paywall.monthlyLabel(region),
                            priceLabel: monthly.localizedPriceString + "/月",
                            subtitle: AppStrings.Paywall.monthlySubtitle(region),
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

                ActionButton(
                    title: isPurchasing ? "處理中..." : AppStrings.Paywall.cta(region),
                    disabled: selectedPackage == nil || isPurchasing
                ) {
                    guard let pkg = selectedPackage else { return }
                    isPurchasing = true
                    Task {
                        let success = await PurchaseManager.shared.purchase(pkg)
                        isPurchasing = false
                        if success { dismiss() }
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
                selectedPackage = annualPackage
            } catch {
                print("Error loading offerings: \(error)")
            }
            isLoading = false
        }
        .interactiveDismissDisabled(isPurchasing)
    }
}
