//
//  CalorieManager.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import SwiftData

@Observable
class CalorieManager {
    var todayEntries: [FoodEntry] = []
    var dailyCalorieTarget: Int = 2000
    var proteinTargetG: Double = 120
    var carbsTargetG: Double = 250
    var fatTargetG: Double = 65

    var totalCalories: Int {
        todayEntries.reduce(0) { $0 + $1.calories }
    }

    var totalProtein: Double {
        todayEntries.reduce(0) { $0 + $1.proteinG }
    }

    var totalCarbs: Double {
        todayEntries.reduce(0) { $0 + $1.carbsG }
    }

    var totalFat: Double {
        todayEntries.reduce(0) { $0 + $1.fatG }
    }

    var remainingCalories: Int {
        dailyCalorieTarget - totalCalories
    }

    var calorieProgress: Double {
        guard dailyCalorieTarget > 0 else { return 0 }
        return min(Double(totalCalories) / Double(dailyCalorieTarget), 1.0)
    }

    func loadTodayEntries(from entries: [FoodEntry]) {
        let calendar = Calendar.current
        todayEntries = entries.filter { calendar.isDateInToday($0.date) }
    }

    func updateTargets(from profile: UserProfile) {
        dailyCalorieTarget = profile.dailyCalorieTarget
        proteinTargetG = profile.proteinTargetG
        carbsTargetG = profile.carbsTargetG
        fatTargetG = profile.fatTargetG
    }
}
