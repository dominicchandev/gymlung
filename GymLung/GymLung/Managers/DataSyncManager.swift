//
//  DataSyncManager.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation
import Supabase

// MARK: - Codable DTOs for Supabase

struct UserProfileDTO: Codable {
    let id: UUID
    let name: String
    let gender: String
    let age: Int
    let heightCm: Double
    let weightKg: Double
    let targetWeightKg: Double?
    let activityLevel: String
    let goal: String
    let dailyCalorieTarget: Int
    let proteinTargetG: Double
    let carbsTargetG: Double
    let fatTargetG: Double
    let onboardingCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, gender, age, goal
        case heightCm = "height_cm"
        case weightKg = "weight_kg"
        case targetWeightKg = "target_weight_kg"
        case activityLevel = "activity_level"
        case dailyCalorieTarget = "daily_calorie_target"
        case proteinTargetG = "protein_target_g"
        case carbsTargetG = "carbs_target_g"
        case fatTargetG = "fat_target_g"
        case onboardingCompleted = "onboarding_completed"
    }
}

struct FoodEntryDTO: Codable {
    let id: UUID
    let userId: UUID
    let name: String
    let calories: Int
    let proteinG: Double
    let carbsG: Double
    let fatG: Double
    let servingSize: String
    let mealType: String
    let date: String
    let photoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, calories, date
        case userId = "user_id"
        case proteinG = "protein_g"
        case carbsG = "carbs_g"
        case fatG = "fat_g"
        case servingSize = "serving_size"
        case mealType = "meal_type"
        case photoUrl = "photo_url"
    }
}

struct FoodDatabaseItemDTO: Codable {
    let id: UUID
    let name: String
    let nameEn: String?
    let calories: Int
    let proteinG: Double
    let carbsG: Double
    let fatG: Double
    let servingSize: String
    let category: String
    let isHkFood: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, calories, category
        case nameEn = "name_en"
        case proteinG = "protein_g"
        case carbsG = "carbs_g"
        case fatG = "fat_g"
        case servingSize = "serving_size"
        case isHkFood = "is_hk_food"
    }
}

// MARK: - DataSyncManager

@Observable
class DataSyncManager {
    var isSyncing = false
    var lastSyncError: String?

    // MARK: - Profile Sync

    func upsertProfile(_ profile: UserProfile, userId: UUID) async {
        let dto = UserProfileDTO(
            id: userId,
            name: profile.name,
            gender: profile.gender,
            age: profile.age,
            heightCm: profile.heightCM,
            weightKg: profile.weightKG,
            targetWeightKg: profile.targetWeightKG,
            activityLevel: profile.activityLevel,
            goal: profile.goal,
            dailyCalorieTarget: profile.dailyCalorieTarget,
            proteinTargetG: profile.proteinTargetG,
            carbsTargetG: profile.carbsTargetG,
            fatTargetG: profile.fatTargetG,
            onboardingCompleted: profile.onboardingCompleted
        )

        do {
            try await SupabaseConfig.client
                .from("user_profiles")
                .upsert(dto)
                .execute()
        } catch {
            lastSyncError = "同步個人資料失敗：\(error.localizedDescription)"
        }
    }

    func fetchProfile(userId: UUID) async -> UserProfileDTO? {
        do {
            let response: [UserProfileDTO] = try await SupabaseConfig.client
                .from("user_profiles")
                .select()
                .eq("id", value: userId)
                .execute()
                .value
            return response.first
        } catch {
            lastSyncError = "取得個人資料失敗：\(error.localizedDescription)"
            return nil
        }
    }

    // MARK: - Food Entry Sync

    func insertFoodEntry(_ entry: FoodEntry, userId: UUID) async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dto = FoodEntryDTO(
            id: entry.id,
            userId: userId,
            name: entry.name,
            calories: entry.calories,
            proteinG: entry.proteinG,
            carbsG: entry.carbsG,
            fatG: entry.fatG,
            servingSize: entry.servingSize,
            mealType: entry.mealType,
            date: dateFormatter.string(from: entry.date),
            photoUrl: nil
        )

        do {
            try await SupabaseConfig.client
                .from("food_entries")
                .insert(dto)
                .execute()
        } catch {
            lastSyncError = "同步食物記錄失敗：\(error.localizedDescription)"
        }
    }

    func deleteFoodEntry(id: UUID) async {
        do {
            try await SupabaseConfig.client
                .from("food_entries")
                .delete()
                .eq("id", value: id)
                .execute()
        } catch {
            lastSyncError = "刪除食物記錄失敗：\(error.localizedDescription)"
        }
    }

    func fetchFoodEntries(userId: UUID, date: Date? = nil) async -> [FoodEntryDTO] {
        do {
            var query = SupabaseConfig.client
                .from("food_entries")
                .select()
                .eq("user_id", value: userId)

            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                query = query.eq("date", value: dateFormatter.string(from: date))
            }

            let response: [FoodEntryDTO] = try await query
                .order("created_at", ascending: false)
                .execute()
                .value
            return response
        } catch {
            lastSyncError = "取得食物記錄失敗：\(error.localizedDescription)"
            return []
        }
    }

    // MARK: - Delete All User Data

    func deleteAllUserData(userId: UUID) async {
        do {
            try await SupabaseConfig.client
                .from("food_entries")
                .delete()
                .eq("user_id", value: userId)
                .execute()
        } catch {
            lastSyncError = "刪除食物記錄失敗：\(error.localizedDescription)"
        }

        do {
            try await SupabaseConfig.client
                .from("user_profiles")
                .delete()
                .eq("id", value: userId)
                .execute()
        } catch {
            lastSyncError = "刪除個人資料失敗：\(error.localizedDescription)"
        }
    }

    // MARK: - Food Database (read-only)

    func searchFoodDatabase(query: String) async -> [FoodDatabaseItemDTO] {
        do {
            let response: [FoodDatabaseItemDTO] = try await SupabaseConfig.client
                .from("food_database")
                .select()
                .ilike("name", pattern: "%\(query)%")
                .limit(20)
                .execute()
                .value
            return response
        } catch {
            lastSyncError = "搜尋食物資料庫失敗：\(error.localizedDescription)"
            return []
        }
    }

    func fetchAllFoodDatabase() async -> [FoodDatabaseItemDTO] {
        do {
            let response: [FoodDatabaseItemDTO] = try await SupabaseConfig.client
                .from("food_database")
                .select()
                .order("category")
                .execute()
                .value
            return response
        } catch {
            lastSyncError = "取得食物資料庫失敗：\(error.localizedDescription)"
            return []
        }
    }
}
