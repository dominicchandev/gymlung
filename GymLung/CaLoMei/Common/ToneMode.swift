//
//  ToneMode.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 26/2/2026.
//

import SwiftUI

enum ToneMode: String, CaseIterable {
    // HK modes
    case normal
    case adult
    case gentle
    // TW modes
    case twGanHua
    case twAma
    case twYanShi

    var displayName: String {
        switch self {
        case .normal: return "老味 ☺️"
        case .adult: return "18+ 🤬"
        case .gentle: return "仁慈 🥺"
        case .twGanHua: return "幹話王 🤡"
        case .twAma: return "阿嬤碎念 👵🏻"
        case .twYanShi: return "厭世仙人掌 🌵"
        }
    }

    var description: String {
        switch self {
        case .normal: return "寸嘴但唔爆粗"
        case .adult: return "係要俾人屌下先會瘦㗎嘛"
        case .gentle: return "溫柔到似幼稚園老師"
        case .twGanHua: return "講幹話但每句都是事實"
        case .twAma: return "有一種胖，叫阿嬤覺得你不夠胖"
        case .twYanShi: return "連吐槽你都懶，但還是會吐槽"
        }
    }

    var roastEmoji: String {
        switch self {
        case .normal: return "☺️"
        case .adult: return "🤬"
        case .gentle: return "🥹"
        case .twGanHua: return "🤡"
        case .twAma: return "👵"
        case .twYanShi: return "🌵"
        }
    }

    var roastColor: Color {
        switch self {
        case .normal: return .orange
        case .adult: return .red
        case .gentle: return .pink
        case .twGanHua: return .yellow
        case .twAma: return .brown
        case .twYanShi: return .green
        }
    }

    /// Available modes for a given region
    static func modes(for region: Region) -> [ToneMode] {
        switch region {
        case .hk: return [.normal, .adult, .gentle]
        case .tw: return [.twGanHua, .twAma, .twYanShi]
        }
    }

    /// Default mode when switching to a region
    static func defaultMode(for region: Region) -> ToneMode {
        switch region {
        case .hk: return .normal
        case .tw: return .twGanHua
        }
    }

    /// Which region this mode belongs to
    var region: Region {
        switch self {
        case .normal, .adult, .gentle: return .hk
        case .twGanHua, .twAma, .twYanShi: return .tw
        }
    }

    var isFree: Bool {
        switch self {
        case .normal, .twGanHua: return true
        case .adult, .gentle, .twAma, .twYanShi: return false
        }
    }
}
