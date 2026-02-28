//
//  Theme.swift
//  GymLung
//
//  Design system: dynamic color themes
//

import SwiftUI

enum Theme {
    // MARK: - Current Theme

    static var current: ColorTheme {
        let raw = UserDefaults.standard.string(forKey: "colorTheme") ?? ColorTheme.amber.rawValue
        return ColorTheme(rawValue: raw) ?? .amber
    }

    // MARK: - Backgrounds

    static var bg: Color {
        switch current {
        case .amber:  return Color(hex: "#0D0D0D")
        case .gold:   return Color(hex: "#121210")
        case .orange: return Color(hex: "#111111")
        }
    }

    static var bgCard: Color {
        switch current {
        case .amber:  return Color(hex: "#1A1A1A")
        case .gold:   return Color(hex: "#1C1B18")
        case .orange: return Color(hex: "#1A1A1A")
        }
    }

    static var bgElevated: Color {
        switch current {
        case .amber:  return Color(hex: "#222222")
        case .gold:   return Color(hex: "#242220")
        case .orange: return Color(hex: "#222222")
        }
    }

    static var bgDivider: Color {
        switch current {
        case .amber:  return Color(hex: "#2A2A2A")
        case .gold:   return Color(hex: "#2A2823")
        case .orange: return Color(hex: "#2A2A2A")
        }
    }

    // MARK: - Neon Accents

    static var neonGreen: Color {
        switch current {
        case .amber:  return Color(hex: "#FFAD33")
        case .gold:   return Color(hex: "#E8A838")
        case .orange: return Color(hex: "#FF6B35")
        }
    }

    static var neonAmber: Color {
        switch current {
        case .amber:  return Color(hex: "#4ECDC4")
        case .gold:   return Color(hex: "#F5E6C8")
        case .orange: return Color(hex: "#FFD60A")
        }
    }

    static var neonRed: Color {
        switch current {
        case .amber:  return Color(hex: "#FF5A5F")
        case .gold:   return Color(hex: "#D95555")
        case .orange: return Color(hex: "#FF3B30")
        }
    }

    static var neonBlue: Color {
        switch current {
        case .amber:  return Color(hex: "#54A0FF")
        case .gold:   return Color(hex: "#7EB5D6")
        case .orange: return Color(hex: "#3B82F6")
        }
    }

    // MARK: - Text

    static let textPrimary = Color.white

    static var textSecondary: Color {
        switch current {
        case .amber:  return Color(hex: "#9A9A9A")
        case .gold:   return Color(hex: "#998B7A")
        case .orange: return Color(hex: "#8E8E93")
        }
    }

    static var textTertiary: Color {
        switch current {
        case .amber:  return Color(hex: "#606060")
        case .gold:   return Color(hex: "#5C5347")
        case .orange: return Color(hex: "#606060")
        }
    }

    static var textMuted: Color {
        switch current {
        case .amber:  return Color(hex: "#404040")
        case .gold:   return Color(hex: "#3D3830")
        case .orange: return Color(hex: "#404040")
        }
    }

    // MARK: - Border

    static var border: Color {
        switch current {
        case .amber:  return Color(hex: "#404040")
        case .gold:   return Color(hex: "#3D3830")
        case .orange: return Color(hex: "#404040")
        }
    }

    // MARK: - Macros

    static var macroProtein: Color {
        switch current {
        case .amber:  return Color(hex: "#FF6B6B")
        case .gold:   return Color(hex: "#E88A6F")
        case .orange: return Color(hex: "#FF6B35")
        }
    }

    static var macroCarbs: Color {
        switch current {
        case .amber:  return Color(hex: "#FFB547")
        case .gold:   return Color(hex: "#E8A838")
        case .orange: return Color(hex: "#FFD60A")
        }
    }

    static var macroFat: Color {
        switch current {
        case .amber:  return Color(hex: "#4ECDC4")
        case .gold:   return Color(hex: "#7EB5D6")
        case .orange: return Color(hex: "#3B82F6")
        }
    }

    // MARK: - State

    static var selectedOptionBg: Color {
        switch current {
        case .amber:  return Color(hex: "#1A2A1A")
        case .gold:   return Color(hex: "#1E1C14")
        case .orange: return Color(hex: "#1F1510")
        }
    }

    // MARK: - BMI

    static func bmiColor(_ bmi: Double) -> Color {
        switch bmi {
        case ..<18.5: return neonBlue
        case 18.5..<24: return neonGreen
        case 24..<28: return neonAmber
        default: return neonRed
        }
    }
}

// MARK: - Neon Glow Modifier

extension View {
    func neonGlow(_ color: Color, radius: CGFloat = 8) -> some View {
        self.shadow(color: color.opacity(0.5), radius: radius / 2, x: 0, y: 0)
            .shadow(color: color.opacity(0.25), radius: radius, x: 0, y: 0)
    }
}
