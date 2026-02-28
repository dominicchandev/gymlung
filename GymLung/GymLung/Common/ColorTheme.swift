//
//  ColorTheme.swift
//  GymLung
//

import Foundation

enum ColorTheme: String, CaseIterable {
    case amber
    case gold
    case orange

    var displayName: String {
        switch self {
        case .amber: return "霓虹夜市"
        case .gold: return "茶記黃金"
        case .orange: return "熱辣辣"
        }
    }

    var emoji: String {
        switch self {
        case .amber: return "🏮"
        case .gold: return "🍳"
        case .orange: return "🌶️"
        }
    }

    var description: String {
        switch self {
        case .amber: return "深水埗霓虹招牌 — 琥珀 × 青"
        case .gold: return "茶餐廳奶茶色 — 金黃 × 暖白"
        case .orange: return "避風塘辣蟹 — 橙紅 × 火黃"
        }
    }
}
