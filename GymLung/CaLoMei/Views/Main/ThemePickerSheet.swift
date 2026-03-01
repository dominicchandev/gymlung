//
//  ThemePickerSheet.swift
//  CaLoMei
//

import SwiftUI

struct ThemePickerSheet: View {
    @AppStorage("colorTheme") private var colorThemeRaw: String = ColorTheme.amber.rawValue
    @Environment(\.dismiss) private var dismiss

    private var currentTheme: ColorTheme {
        ColorTheme(rawValue: colorThemeRaw) ?? .amber
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("主題色 (Dev)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 8)

                    ForEach(ColorTheme.allCases, id: \.rawValue) { theme in
                        Button(action: {
                            colorThemeRaw = theme.rawValue
                        }) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 6) {
                                        Text(theme.emoji)
                                            .font(.system(size: 18))
                                        Text(theme.displayName)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }

                                    Text(theme.description)
                                        .font(.system(size: 13))
                                        .foregroundColor(Theme.textSecondary)

                                    // Color swatch dots
                                    HStack(spacing: 6) {
                                        SwatchDot(theme: theme, keyPath: \.neonGreen)
                                        SwatchDot(theme: theme, keyPath: \.neonAmber)
                                        SwatchDot(theme: theme, keyPath: \.neonRed)
                                        SwatchDot(theme: theme, keyPath: \.macroProtein)
                                        SwatchDot(theme: theme, keyPath: \.macroFat)
                                    }
                                    .padding(.top, 4)
                                }

                                Spacer()

                                if currentTheme == theme {
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
                                                currentTheme == theme ? Theme.neonGreen : Color.clear,
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
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.neonGreen)
                }
            }
        }
    }
}

// MARK: - Swatch Dot

private struct SwatchDot: View {
    let color: Color

    init(theme: ColorTheme, keyPath: KeyPath<ThemeColors, Color>) {
        self.color = ThemeColors(theme: theme)[keyPath: keyPath]
    }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }
}

/// Helper to resolve theme colors for a specific theme (used by swatch preview)
private struct ThemeColors {
    let theme: ColorTheme

    var neonGreen: Color {
        switch theme {
        case .amber:  return Color(hex: "#FFAD33")
        case .gold:   return Color(hex: "#E8A838")
        case .orange: return Color(hex: "#FF6B35")
        }
    }

    var neonAmber: Color {
        switch theme {
        case .amber:  return Color(hex: "#4ECDC4")
        case .gold:   return Color(hex: "#F5E6C8")
        case .orange: return Color(hex: "#FFD60A")
        }
    }

    var neonRed: Color {
        switch theme {
        case .amber:  return Color(hex: "#FF5A5F")
        case .gold:   return Color(hex: "#D95555")
        case .orange: return Color(hex: "#FF3B30")
        }
    }

    var macroProtein: Color {
        switch theme {
        case .amber:  return Color(hex: "#FF6B6B")
        case .gold:   return Color(hex: "#E88A6F")
        case .orange: return Color(hex: "#FF6B35")
        }
    }

    var macroFat: Color {
        switch theme {
        case .amber:  return Color(hex: "#4ECDC4")
        case .gold:   return Color(hex: "#7EB5D6")
        case .orange: return Color(hex: "#3B82F6")
        }
    }
}
