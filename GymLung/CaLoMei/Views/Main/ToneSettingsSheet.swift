//
//  ToneSettingsSheet.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 26/2/2026.
//

import SwiftUI

struct ToneSettingsSheet: View {
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @AppStorage("region") private var regionRaw: String = Region.deviceDefault.rawValue
    @Environment(\.dismiss) private var dismiss
    @State private var showAgeConfirm = false
    @State private var showPaywall = false

    private var currentMode: ToneMode {
        ToneMode(rawValue: toneModeRaw) ?? .normal
    }

    private var currentRegion: Region {
        Region(rawValue: regionRaw) ?? .hk
    }

    private var availableModes: [ToneMode] {
        ToneMode.modes(for: currentRegion)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("語氣模式")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    ForEach(availableModes, id: \.rawValue) { mode in
                        Button(action: {
                            if mode.isFree || PurchaseManager.shared.isPro {
                                if mode == .adult && currentMode != .adult {
                                    showAgeConfirm = true
                                } else {
                                    toneModeRaw = mode.rawValue
                                }
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    showPaywall = true
                                }
                            }
                        }) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(mode.displayName)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)

                                        if !mode.isFree {
                                            ProBadge()
                                        }
                                    }

                                    Text(mode.description)
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textSecondary)

                                    Text(previewText(for: mode))
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textTertiary)
                                        .italic()
                                        .padding(.top, 2)
                                }

                                Spacer()

                                if currentMode == mode {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Theme.neonGreen)
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Theme.bgCard)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(
                                                currentMode == mode ? Theme.neonGreen : Color.clear,
                                                lineWidth: 1.5
                                            )
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(currentRegion == .tw ? "OK" : "搞掂") {
                        dismiss()
                    }
                    .foregroundColor(Theme.neonGreen)
                }
            }
            .alert("你夠18歲未？", isPresented: $showAgeConfirm) {
                Button("夠喇", role: .none) {
                    toneModeRaw = ToneMode.adult.rawValue
                }
                Button("未夠", role: .cancel) {}
            } message: {
                Text("粗口模式得18歲以上先用得")
            }
            .sheet(isPresented: $showPaywall) {
                PaywallSheet(trigger: .toneLock)
            }
        }
    }

    private func previewText(for mode: ToneMode) -> String {
        switch mode {
        // HK
        case .normal: return "「又食嘢？記低佢」"
        case .adult: return "「又食嘢？記低佢啦屌」"
        case .gentle: return "「記錄食物 🍽️」"
        // TW
        case .twGanHua: return "「根據統計，吃完這包的人100%都會胖」"
        case .twAma: return "「又吃炸的喔？你媽知道嗎？」"
        case .twYanShi: return "「...又是珍奶。算了，你開心就好」"
        }
    }
}
