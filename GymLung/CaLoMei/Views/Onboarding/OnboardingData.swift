//
//  OnboardingData.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import Foundation

enum OnboardingPage: String, CaseIterable {
    case welcome
    case gender
    case age
    case heightWeight
    case activityLevel
    case goal
    case targetWeight
    case mealTimes
    case summary
    case paywall
}

struct OnboardingQuestionData {
    static let genderOptions: [(title: String, icon: String)] = [
        ("男", "👨🏻"),
        ("女", "👩🏻"),
    ]

    static let ageRanges: [(title: String, subtitle: String)] = [
        ("18-25", "後生仔女"),
        ("26-35", "打緊工嘅年紀"),
        ("36-45", "中年黃金期"),
        ("46-55", "壯年期"),
        ("56+", "保持健康"),
    ]

    static let activityLevels: [(title: String, subtitle: String, icon: String)] = [
        ("好少運動", "淨係識躺平", "🪑"),
        ("輕度運動", "行去買珍奶都計", "🚶🏻"),
        ("中等運動", "起碼有出過汗", "🏃🏻"),
        ("高強度運動", "你嚟呢度做咩", "🏋🏻"),
    ]

    static let goalOptions: [(title: String, subtitle: String, icon: String)] = [
        ("減脂", "係時候面對現實", "🔥"),
        ("維持體重", "即係覺得自己OK㗎？", "⚖️"),
        ("增肌", "排骨想變大隻", "💪"),
    ]

    /// Common HK foods for demo data
    static let sampleFoods: [(name: String, calories: Int, protein: Double, carbs: Double, fat: Double, meal: String)] = [
        ("叉燒飯", 680, 32, 85, 22, "午餐"),
        ("雲吞麵", 380, 18, 45, 12, "午餐"),
        ("菠蘿油", 340, 6, 42, 18, "早餐"),
        ("公仔麵", 450, 10, 58, 20, "晚餐"),
        ("燒味飯", 720, 35, 80, 28, "午餐"),
        ("蛋撻", 180, 4, 20, 10, "小食"),
        ("魚蛋", 120, 12, 8, 5, "小食"),
        ("奶茶", 150, 3, 22, 6, "早餐"),
        ("雞蛋三文治", 280, 14, 28, 12, "早餐"),
        ("燒賣", 200, 10, 15, 11, "小食"),
        ("腸粉", 220, 8, 30, 7, "早餐"),
        ("西多士", 420, 10, 38, 26, "早餐"),
        ("牛腩麵", 520, 28, 50, 22, "午餐"),
        ("雞翼", 280, 22, 2, 20, "小食"),
        ("白飯 (1碗)", 240, 4, 53, 0.4, "午餐"),
        ("雞胸肉 (150g)", 248, 46, 0, 5.4, "晚餐"),
        ("烚蛋 (2隻)", 156, 12, 1.2, 10, "早餐"),
        ("肉餅飯", 580, 28, 72, 18, "午餐"),
        ("燒鵝飯", 780, 38, 75, 35, "午餐"),
        ("甘一刀叉燒", 350, 25, 15, 22, "午餐"),
        ("珍珠奶茶", 480, 2, 68, 18, "小食"),
        ("麥當勞巨無霸", 550, 25, 45, 30, "午餐"),
        ("炸雞髀", 380, 28, 12, 25, "晚餐"),
    ]
}

// MARK: - Food Roast Comments (meme-powered)

struct FoodRoasts {
    /// Returns a snarky meme comment for a food name, or a generic roast
    static func roast(for foodName: String) -> String {
        // Check meme-specific roasts first
        for (keyword, comment) in memeRoasts {
            if foodName.contains(keyword) {
                return comment
            }
        }
        // Check generic roasts
        for (keyword, comment) in genericRoasts {
            if foodName.contains(keyword) {
                return comment
            }
        }
        // Fallback random roasts
        return fallbackRoasts.randomElement()!
    }

    // MARK: - HK Meme References

    private static let memeRoasts: [(String, String)] = [
        // 大寶冰室肉餅飯 meme
        ("肉餅飯", "全亞洲最優秀嘅肉餅飯 🏆 食完記得排隊排到元朗"),
        ("肉餅", "大寶冰室都冇你食得咁密"),
        // 廿四味 Brian dope叉燒 meme
        ("甘一刀叉燒", "叉燒界Hermès 🔥 要着兩條褲去食"),
        ("叉燒", "dope 🔥 但你個卡路里唔dope"),
        // 燒鵝都dope
        ("燒鵝", "燒鵝都dope 但你嘅體重都dope"),
        ("燒味", "dope到要着兩條褲 不過你可能已經着唔到"),
    ]

    // MARK: - Generic Food Roasts

    private static let genericRoasts: [(String, String)] = [
        ("公仔麵", "消夜食呢啲 唔肥都假"),
        ("菠蘿油", "一個菠蘿油340kcal 你估食緊沙律？"),
        ("西多士", "炸完再淋糖漿 你係認真㗎？"),
        ("奶茶", "又飲 唔怕糖尿？"),
        ("珍珠奶茶", "一杯珍奶 = 一碗飯 你自己諗"),
        ("蛋撻", "一個唔夠 你一定食幾個"),
        ("雞翼", "走雞皮？你呃邊個"),
        ("炸雞", "KFC定自己炸 都係一樣咁肥"),
        ("巨無霸", "加大餐定普通餐？算啦問嚟都多餘"),
        ("薯條", "薯條係蔬菜？你開心就好"),
        ("雪糕", "食完正餐仲要食甜品 佩服你"),
        ("蛋糕", "生日都唔係 食咩蛋糕"),
        ("pizza", "一塊？你會食一塊就收手？"),
        ("漢堡", "又食垃圾食物 今日第幾次"),
        ("雞胸肉", "健康嘢喎 難得你識食"),
        ("烚蛋", "OK 起碼你有試過健康"),
        ("沙律", "沙律醬落幾多先？"),
        ("牛腩", "好食係好食 但520kcal喎大佬"),
        ("魚蛋", "街邊魚蛋 醬撈到癲 你計咗醬未"),
        ("燒賣", "7-11燒賣定點心燒賣 都係垃圾啦"),
    ]

    // MARK: - Fallback Roasts (when no keyword match)

    private static let fallbackRoasts: [String] = [
        "又食 你唔攰個胃都攰",
        "食完記得內疚",
        "你個肚唔係垃圾桶嚟㗎",
        "今日嘅卡路里 聽日嘅脂肪",
        "食得開心？等陣上磅就知",
        "你確定要食？算啦你都會食",
        "自己攞嚟㗎 怨唔到人",
        "食多一啖 離目標又遠一步",
        "你嘅意志力同你嘅腰圍成反比",
        "記低先 唔好呃自己",
    ]
}
