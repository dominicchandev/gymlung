//
//  FoodEntry.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var name: String
    var calories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var servingSize: String  // e.g. "1碗", "1件", "100g"
    var mealType: String     // legacy — no longer used for UI grouping
    var date: Date
    var createdAt: Date
    @Attribute(.externalStorage) var imageData: Data?

    init(
        name: String,
        calories: Int,
        proteinG: Double = 0,
        carbsG: Double = 0,
        fatG: Double = 0,
        servingSize: String = "1份",
        mealType: String = "午餐",
        date: Date = Date(),
        imageData: Data? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.proteinG = proteinG
        self.carbsG = carbsG
        self.fatG = fatG
        self.servingSize = servingSize
        self.mealType = mealType
        self.date = date
        self.createdAt = Date()
        self.imageData = imageData
    }
}
