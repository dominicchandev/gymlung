//
//  UserProfile.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var gender: String          // "男" / "女"
    var age: Int
    var heightCM: Double        // cm
    var weightKG: Double        // kg
    var targetWeightKG: Double? // kg (optional)
    var activityLevel: String   // "好少運動" / "輕度運動" / "中等運動" / "高強度運動"
    var goal: String            // "減脂" / "維持體重" / "增肌"
    var dailyCalorieTarget: Int
    var proteinTargetG: Double
    var carbsTargetG: Double
    var fatTargetG: Double
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastLogDate: Date?
    var streakBrokenShown: Bool = false
    var createdAt: Date
    var onboardingCompleted: Bool

    init(
        name: String = "",
        gender: String = "",
        age: Int = 25,
        heightCM: Double = 170,
        weightKG: Double = 65,
        targetWeightKG: Double? = nil,
        activityLevel: String = "輕度運動",
        goal: String = "維持體重",
        dailyCalorieTarget: Int = 2000,
        proteinTargetG: Double = 120,
        carbsTargetG: Double = 250,
        fatTargetG: Double = 65,
        onboardingCompleted: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.gender = gender
        self.age = age
        self.heightCM = heightCM
        self.weightKG = weightKG
        self.targetWeightKG = targetWeightKG
        self.activityLevel = activityLevel
        self.goal = goal
        self.dailyCalorieTarget = dailyCalorieTarget
        self.proteinTargetG = proteinTargetG
        self.carbsTargetG = carbsTargetG
        self.fatTargetG = fatTargetG
        self.createdAt = Date()
        self.onboardingCompleted = onboardingCompleted
    }
}
