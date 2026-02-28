//
//  WeightEntry.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var weightKG: Double
    var date: Date
    var createdAt: Date

    init(
        weightKG: Double,
        date: Date = Date()
    ) {
        self.id = UUID()
        self.weightKG = weightKG
        self.date = date
        self.createdAt = Date()
    }
}
