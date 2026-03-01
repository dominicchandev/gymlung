//
//  Region.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 28/2/2026.
//

import Foundation

enum Region: String, CaseIterable {
    case hk
    case tw

    var displayName: String {
        switch self {
        case .hk: return "香港"
        case .tw: return "台灣"
        }
    }

    var flag: String {
        switch self {
        case .hk: return "🇭🇰"
        case .tw: return "🇹🇼"
        }
    }

    /// Detect default region from device locale
    static var deviceDefault: Region {
        let regionCode = Locale.current.region?.identifier ?? ""
        switch regionCode {
        case "TW": return .tw
        default: return .hk
        }
    }
}
