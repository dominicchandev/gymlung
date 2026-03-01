//
//  FoodComponent.swift
//  CaLoMei
//
//  Created by Claude on 28/2/2026.
//

import Foundation

struct FoodComponent: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var nameZH: String
    var nameEN: String
    var calories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var portionDescription: String
    var confidence: Double
    var isExcluded: Bool = false
}
