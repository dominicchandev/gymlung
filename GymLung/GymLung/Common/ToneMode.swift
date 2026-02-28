//
//  ToneMode.swift
//  GymLung
//
//  Created by Chan Tin Lok on 26/2/2026.
//

import Foundation

enum ToneMode: String, CaseIterable {
    case normal
    case adult
    case gentle

    var displayName: String {
        switch self {
        case .normal: return "串嘴 ☺️"
        case .adult: return "18+ 🤬"
        case .gentle: return "仁慈 🥺"
        }
    }

    var description: String {
        switch self {
        case .normal: return "寸嘴但唔爆粗"
        case .adult: return "係要俾人屌下先會瘦㗎嘛"
        case .gentle: return "溫柔到似幼稚園老師"
        }
    }

    var roastEmoji: String {
        switch self {
        case .normal: return "☺️"
        case .adult: return "🤬"
        case .gentle: return "🥹"
        }
    }
}
