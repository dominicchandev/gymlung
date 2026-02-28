//
//  RegionPickerSheet.swift
//  GymLung
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import SwiftUI

struct RegionPickerSheet: View {
    @Binding var regionRaw: String
    @Binding var toneModeRaw: String
    @Environment(\.dismiss) private var dismiss

    private var currentRegion: Region {
        Region(rawValue: regionRaw) ?? .hk
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("地區")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    ForEach(Region.allCases, id: \.rawValue) { region in
                        Button(action: {
                            switchRegion(to: region)
                        }) {
                            HStack(spacing: 16) {
                                Text(region.flag)
                                    .font(.system(size: 28))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(region.displayName)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)

                                    Text(regionDescription(region))
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textSecondary)
                                }

                                Spacer()

                                if currentRegion == region {
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
                                                currentRegion == region ? Theme.neonGreen : Color.clear,
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
                    Button("OK") {
                        dismiss()
                    }
                    .foregroundColor(Theme.neonGreen)
                }
            }
        }
    }

    private func regionDescription(_ region: Region) -> String {
        switch region {
        case .hk: return "廣東話語氣模式"
        case .tw: return "台灣中文語氣模式"
        }
    }

    private func switchRegion(to region: Region) {
        guard region != currentRegion else { return }
        regionRaw = region.rawValue
        // Auto-switch tone to default for the new region
        toneModeRaw = ToneMode.defaultMode(for: region).rawValue
    }
}
