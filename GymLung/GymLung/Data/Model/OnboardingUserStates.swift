//
//  OnboardingUserStates.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation

struct OnboardingUserStates {
    var name: String = ""
    var gender: String = ""          // "男" / "女"
    var birthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    var heightCM: Double = 170
    var weightKG: Double = 65
    var targetWeightKG: Double = 60
    var activityLevel: String = ""   // "好少運動" / "輕度運動" / "中等運動" / "高強度運動"
    var goal: String = ""            // "減脂" / "維持體重" / "增肌"
    var breakfastTime: Date = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    var lunchTime: Date = Calendar.current.date(from: DateComponents(hour: 12, minute: 30)) ?? Date()
    var dinnerTime: Date = Calendar.current.date(from: DateComponents(hour: 19, minute: 0)) ?? Date()

    /// Age computed from birthday
    var age: Int {
        Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 25
    }

    /// Calculate BMR using Mifflin-St Jeor equation
    var bmr: Double {
        if gender == "男" {
            return 10 * weightKG + 6.25 * heightCM - 5 * Double(age) + 5
        } else {
            return 10 * weightKG + 6.25 * heightCM - 5 * Double(age) - 161
        }
    }

    /// Activity multiplier
    var activityMultiplier: Double {
        switch activityLevel {
        case "好少運動": return 1.2
        case "輕度運動": return 1.375
        case "中等運動": return 1.55
        case "高強度運動": return 1.725
        default: return 1.375
        }
    }

    /// TDEE (Total Daily Energy Expenditure)
    var tdee: Double {
        bmr * activityMultiplier
    }

    /// Recommended daily calories based on goal
    var recommendedCalories: Int {
        switch goal {
        case "減脂": return Int(tdee - 500)
        case "增肌": return Int(tdee + 300)
        default: return Int(tdee)
        }
    }

    /// Recommended protein (g)
    var recommendedProtein: Double {
        switch goal {
        case "減脂": return weightKG * 2.0
        case "增肌": return weightKG * 2.2
        default: return weightKG * 1.6
        }
    }

    /// Recommended fat (g) — ~25% of calories
    var recommendedFat: Double {
        Double(recommendedCalories) * 0.25 / 9.0
    }

    /// Recommended carbs (g) — remaining calories
    var recommendedCarbs: Double {
        let proteinCals = recommendedProtein * 4.0
        let fatCals = recommendedFat * 9.0
        return (Double(recommendedCalories) - proteinCals - fatCals) / 4.0
    }
}
