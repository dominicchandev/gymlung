//
//  PaywallSheet.swift
//  CaLoMei
//

import SwiftUI
import RevenueCat

struct PaywallSheet: View {
    var trigger: PaywallTrigger = .scanLimit(gender: "")
    @Environment(\.dismiss) private var dismiss
    @AppStorage("region") private var regionRaw: String = Region.hk.rawValue
    private var region: Region { Region(rawValue: regionRaw) ?? .hk }

    @State private var offerings: Offerings?
    @State private var selectedPackage: Package?
    @State private var isLoading = false
    @State private var isPurchasing = false
    @State private var isTrialEligible = false

    private var annualPackage: Package? { offerings?.current?.annual }
    private var monthlyPackage: Package? { offerings?.current?.monthly }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Circle().fill(Theme.bgCard))
                    }
                    Spacer()

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

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: 20)

                        Text("PRO")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Theme.neonGreen))

                        Spacer().frame(height: 16)

                        Text(AppStrings.Paywall.title(for: trigger, region))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 8)

                        Text(isTrialEligible
                            ? AppStrings.Paywall.subtitleTrial(for: trigger, region)
                            : AppStrings.Paywall.subtitle(for: trigger, region))
                            .font(.system(size: 15))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        Spacer().frame(height: 32)

                        VStack(spacing: 16) {
                            PaywallFeatureRow(icon: "camera.fill", text: AppStrings.Paywall.feature1(region))
                            PaywallFeatureRow(icon: "chart.bar.fill", text: AppStrings.Paywall.feature2(region))
                            PaywallFeatureRow(icon: "theatermasks.fill", text: AppStrings.Paywall.feature3(region))
                            PaywallFeatureRow(icon: "infinity", text: AppStrings.Paywall.feature4(region))
                        }
                        .padding(.horizontal, 32)

                        Spacer().frame(height: 28)

                        // Trial timeline
                        if isTrialEligible {
                            VStack(spacing: 0) {
                                trialTimelineRow(
                                    step: "1",
                                    title: region == .hk ? "今日" : "今天",
                                    subtitle: AppStrings.Paywall.timelineToday(region),
                                    isLast: false
                                )
                                trialTimelineRow(
                                    step: "2",
                                    title: region == .hk ? "第2日" : "第2天",
                                    subtitle: AppStrings.Paywall.timelineReminder(region),
                                    isLast: false
                                )
                                trialTimelineRow(
                                    step: "3",
                                    title: region == .hk ? "第3日" : "第3天",
                                    subtitle: AppStrings.Paywall.timelineBilling(region),
                                    isLast: true
                                )
                            }
                            .padding(.horizontal, 32)

                            Spacer().frame(height: 24)
                        }

                        // Package selection
                        if let monthly = monthlyPackage, let annual = annualPackage {
                            VStack(spacing: 12) {
                                PaywallOptionCard(
                                    label: AppStrings.Paywall.annualLabel(region),
                                    priceLabel: isTrialEligible
                                        ? AppStrings.Paywall.annualPriceWithTrial(annual.localizedPriceString, region)
                                        : annual.localizedPriceString + "/年",
                                    subtitle: AppStrings.Paywall.annualSubtitle(region),
                                    badge: isTrialEligible
                                        ? AppStrings.Paywall.trialBadge(region)
                                        : AppStrings.Paywall.saveBadge(region),
                                    bubbleTeaCount: 6,
                                    isSelected: selectedPackage?.identifier == annual.identifier,
                                    onTap: { selectedPackage = annual }
                                )
                                PaywallOptionCard(
                                    label: AppStrings.Paywall.monthlyLabel(region),
                                    priceLabel: isTrialEligible
                                        ? AppStrings.Paywall.monthlyPriceWithTrial(monthly.localizedPriceString, region)
                                        : monthly.localizedPriceString + "/月",
                                    subtitle: AppStrings.Paywall.monthlySubtitle(region),
                                    badge: isTrialEligible ? AppStrings.Paywall.trialBadge(region) : nil,
                                    bubbleTeaCount: 1,
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
                            title: isPurchasing
                                ? "處理中..."
                                : (isTrialEligible
                                    ? AppStrings.Paywall.ctaTrial(region)
                                    : AppStrings.Paywall.cta(region)),
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

                        // Disclosure text
                        if isTrialEligible {
                            Text(AppStrings.Paywall.trialDisclosure(region))
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textSecondary.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                        }

                        // Terms & Privacy links
                        HStack(spacing: 16) {
                            Link("使用條款",
                                 destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textSecondary.opacity(0.5))

                            Text("·")
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textSecondary.opacity(0.3))

                            Link("私隱政策",
                                 destination: URL(string: "https://calomei.vercel.app/privacy-policy")!)
                                .font(.system(size: 11))
                                .foregroundColor(Theme.textSecondary.opacity(0.5))
                        }
                        .padding(.top, 8)

                        Spacer().frame(height: 32)
                    }
                }
            }
        }
        .task {
            isLoading = true
            do {
                offerings = try await Purchases.shared.offerings()
                selectedPackage = annualPackage

                // Check trial eligibility
                var productIds: [String] = []
                if let monthly = monthlyPackage {
                    productIds.append(monthly.storeProduct.productIdentifier)
                }
                if let annual = annualPackage {
                    productIds.append(annual.storeProduct.productIdentifier)
                }
                if !productIds.isEmpty {
                    let eligibility = await Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIds)
                    isTrialEligible = eligibility.values.contains { $0.status == .eligible }
                }
            } catch {
                debugPrint("[PAYWALL_SHEET] Error loading offerings: \(error)")
            }
            isLoading = false
        }
        .interactiveDismissDisabled(isPurchasing)
    }

    // MARK: - Trial Timeline Row

    @ViewBuilder
    private func trialTimelineRow(step: String, title: String, subtitle: String, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Theme.neonGreen)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text(step)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                    )
                if !isLast {
                    Rectangle()
                        .fill(Theme.border)
                        .frame(width: 2, height: 28)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.top, 2)

            Spacer()
        }
    }
}
