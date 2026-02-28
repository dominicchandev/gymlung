//
//  AppStrings.swift
//  GymLung
//
//  Created by Chan Tin Lok on 26/2/2026.
//

import Foundation

// MARK: - App-wide tone-aware strings

enum AppStrings {

    // MARK: - Sign In Page

    struct SignIn {
        static func tagline(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "專鬧你食垃圾嘅 app"
            case .adult: return "專屌你食垃圾嘅 app"
            case .gentle: return "你嘅健康小幫手 ✨"
            }
        }
        static func feature1(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "影相就知你食咗幾多垃圾"
            case .adult: return "影相就知你偷食咗啲咩"
            case .gentle: return "影相就可以記錄飲食～"
            }
        }
        static func feature2(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幫你數下你食咗幾多嘢"
            case .adult: return "記低你每日嘅罪行"
            case .gentle: return "輕鬆追蹤每日營養 💪"
            }
        }
        static func feature3(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "香港垃圾食物資料庫 啱晒你"
            case .adult: return "收錄晒你成日食嘅嘢"
            case .gentle: return "超多香港地道食物資料庫～"
            }
        }
        static func skipButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "唔登入直接用"
            case .adult: return "懶登入直接用"
            case .gentle: return "先體驗一下～"
            }
        }
    }

    // MARK: - Welcome Page

    struct Welcome {
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "專鬧你食垃圾嘅 app"
            case .adult: return "專屌你食垃圾嘅 app"
            case .gentle: return "你嘅健康小幫手 ✨"
            }
        }
        static func nameQuestion(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "叫咩名"
            case .adult: return "叫咩名"
            case .gentle: return "你叫咩名呀～"
            }
        }
        static func namePlaceholder(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "打嚟啦"
            case .adult: return "快啲打啦屌"
            case .gentle: return "打你個靚名出嚟～"
            }
        }
    }

    // MARK: - Gender Page

    struct Gender {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "男定女"
            case .adult: return "男定女"
            case .gentle: return "你嘅性別係～"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要嚟計你有幾肥"
            case .adult: return "唔係八卦 計數要用"
            case .gentle: return "我哋需要呢個資料先幫到你 💪"
            }
        }
    }

    // MARK: - Age Page

    struct Age {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幾時出世"
            case .adult: return "幾時出世"
            case .gentle: return "你嘅生日係～"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "唔使扮後生 我計到㗎"
            case .adult: return "生日唔會呃人"
            case .gentle: return "每個生日都值得慶祝 🎂"
            }
        }
    }

    // MARK: - Height/Weight Page

    struct HeightWeight {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幾高幾重"
            case .adult: return "幾高幾重"
            case .gentle: return "你嘅身高同體重～"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "等我睇下你有幾肥"
            case .adult: return "等我睇下你有幾撚肥"
            case .gentle: return "呢個幫我哋更加了解你 💕"
            }
        }
        static func bmiCategory(_ bmi: Double, _ m: ToneMode) -> String {
            switch (bmi, m) {
            case (..<18.5, .normal): return "排骨精"
            case (..<18.5, .adult): return "食撚多啲啦瘦成咁"
            case (..<18.5, .gentle): return "偏瘦少少，記得多食啲呀～"
            case (18.5..<24, .normal): return "算啦 唔肥"
            case (18.5..<24, .adult): return "OK啦 未算太柒"
            case (18.5..<24, .gentle): return "好標準呀！繼續保持 ✨"
            case (24..<28, .normal): return "姐係有少少肥咁 少少🤏"
            case (24..<28, .adult): return "屌 真係肥咗喎"
            case (24..<28, .gentle): return "有少少超標，冇問題㗎～"
            case (_, .normal): return "...兄弟你認真㗎？"
            case (_, .adult): return "仆街 你認真㗎？"
            case (_, .gentle): return "我哋一齊努力，一定得㗎！💪"
            }
        }
    }

    // MARK: - Activity Level Page

    struct ActivityLevel {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你有做運動㗎嘛？"
            case .adult: return "有冇做運動㗎"
            case .gentle: return "你平時鍾唔鍾意做運動呀？"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "定係淨係識攤喺度"
            case .adult: return "定係淨係識攤喺度做廢柒"
            case .gentle: return "冇做都唔緊要㗎，慢慢嚟～"
            }
        }
        static func levelSubtitle(_ title: String, _ m: ToneMode) -> String {
            switch (title, m) {
            case ("好少運動", .normal): return "淨係識躺平"
            case ("好少運動", .adult): return "躺平等死"
            case ("好少運動", .gentle): return "休息都係一種充電～"
            case ("輕度運動", .normal): return "行去買珍奶都計"
            case ("輕度運動", .adult): return "行去買珍奶都算？"
            case ("輕度運動", .gentle): return "有郁動就好好呀！"
            case ("中等運動", .normal): return "起碼有出過汗"
            case ("中等運動", .adult): return "起碼出過汗"
            case ("中等運動", .gentle): return "好叻呀，繼續保持！✨"
            case ("高強度運動", .normal): return "你嚟呢度做咩"
            case ("高強度運動", .adult): return "你嚟呢度做鳩咩"
            case ("高強度運動", .gentle): return "勁呀你！超級自律！💪"
            default: return ""
            }
        }
    }

    // MARK: - Goal Page

    struct Goal {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "想點"
            case .adult: return "想點"
            case .gentle: return "你嘅小目標係咩呀？"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "老實講 唔好呃自己"
            case .adult: return "講清楚 唔好兜"
            case .gentle: return "每個目標都值得被支持 💕"
            }
        }
        static func goalSubtitle(_ goal: String, _ m: ToneMode) -> String {
            switch (goal, m) {
            case ("減脂", .normal): return "係時候面對現實"
            case ("減脂", .adult): return "係時候面對現實啦"
            case ("減脂", .gentle): return "你已經好靚，但可以更好～"
            case ("維持體重", .normal): return "即係覺得自己OK㗎？"
            case ("維持體重", .adult): return "即係覺得自己OK㗎？真㗎？"
            case ("維持體重", .gentle): return "保持現狀都好叻㗎！"
            case ("增肌", .normal): return "排骨想變大隻"
            case ("增肌", .adult): return "排骨想變大隻"
            case ("增肌", .gentle): return "增肌之路，一齊行！💪"
            default: return ""
            }
        }
    }

    // MARK: - Target Weight Page

    struct TargetWeight {
        static func title(_ goal: String, _ m: ToneMode) -> String {
            switch (goal, m) {
            case ("減脂", .normal): return "想瘦到幾多"
            case ("減脂", .adult): return "想瘦到幾撚多"
            case ("增肌", .normal): return "想大隻到幾多"
            case ("增肌", .adult): return "想大隻到幾撚多"
            case ("維持體重", .normal): return "維持喺邊度"
            case ("維持體重", .adult): return "維持喺邊度"
            case (_, .gentle): return "你嘅理想體重～"
            default: return "目標體重"
            }
        }
        static func subtitleMaintain(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "滿意自己？好自信喎"
            case .adult: return "咁你幾滿意自己喎"
            case .gentle: return "好欣賞你接受自己 💕"
            }
        }
        static func subtitle(_ goal: String, _ m: ToneMode) -> String {
            switch (goal, m) {
            case ("減脂", .normal): return "揀個數字 realistic啲"
            case ("減脂", .adult): return "講個合理數字 唔好發夢"
            case ("增肌", .normal): return "想增幾多 唔好離地"
            case ("增肌", .adult): return "想增到幾重 唔好痴心妄想"
            case (_, .gentle): return "設定一個舒服嘅目標就好～"
            default: return "揀個數字 realistic啲"
            }
        }
        static func currentLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "現實"
            case .adult: return "而家嘅你"
            case .gentle: return "而家嘅你 ✨"
            }
        }
        static func targetLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "發夢"
            case .adult: return "發夢"
            case .gentle: return "未來嘅你 💫"
            }
        }
        static func gainLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要增"
            case .adult: return "要增"
            case .gentle: return "需要調整"
            }
        }
        static func lossLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要減"
            case .adult: return "要減"
            case .gentle: return "需要調整"
            }
        }
        static func timeEstimate(_ weeks: Int, _ m: ToneMode) -> String {
            switch m {
            case .normal: return "大約 \(weeks) 星期（你忍唔忍到就另計）"
            case .adult: return "大約 \(weeks) 星期（如果你忍到嘴）"
            case .gentle: return "大約 \(weeks) 星期，慢慢嚟唔使急～"
            }
        }
    }

    // MARK: - Meal Times Page

    struct MealTimes {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幾時開餐"
            case .adult: return "幾時食飯"
            case .gentle: return "你通常幾時食飯呀？"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "等我到時捉你偷食"
            case .adult: return "等我到時提你認罪"
            case .gentle: return "我會溫馨提醒你～"
            }
        }
        static func breakfastLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "早餐"
            case .adult: return "早餐"
            case .gentle: return "早餐 🌅"
            }
        }
        static func lunchLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "午餐"
            case .adult: return "午餐"
            case .gentle: return "午餐 ☀️"
            }
        }
        static func dinnerLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "晚餐"
            case .adult: return "晚餐"
            case .gentle: return "晚餐 🌙"
            }
        }
        static func notificationHint(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "走唔甩㗎 到時會捉你"
            case .adult: return "到時會提你認罪"
            case .gentle: return "我會喺呢啲時間溫馨提醒你～"
            }
        }
    }

    // MARK: - Paywall Page

    struct Paywall {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "想瘦？升級啦"
            case .adult: return "升級做 Pro"
            case .gentle: return "解鎖全部功能～"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "免費版夠你用 但你瘦唔到唔好怪我"
            case .adult: return "免費版夠你用 但Pro版屌你屌得更狠"
            case .gentle: return "更多功能幫你達成目標 ✨"
            }
        }
        static func feature1(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "AI幫你認食物 唔使自己打"
            case .adult: return "AI影相辨識食物"
            case .gentle: return "AI影相辨識食物 📸"
            }
        }
        static func feature2(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "營養report 睇清楚你食咗啲咩"
            case .adult: return "詳細營養分析報告"
            case .gentle: return "詳細營養分析報告 📊"
            }
        }
        static func feature3(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "到時到候提你認數"
            case .adult: return "自訂提醒時間"
            case .gentle: return "自訂提醒時間 🔔"
            }
        }
        static func feature4(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "獨家毒舌語錄"
            case .adult: return "獨家18+毒舌語錄"
            case .gentle: return "更多鼓勵語錄 🔥"
            }
        }
        static func annualLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "年費（識計數）"
            case .adult: return "年費"
            case .gentle: return "年費計劃"
            }
        }
        static func monthlyLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "月費（貴啲㗎）"
            case .adult: return "月費"
            case .gentle: return "月費計劃"
            }
        }
        static func saveBadge(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "識揀"
            case .adult: return "抵啲"
            case .gentle: return "最受歡迎"
            }
        }
        static func cta(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "好啦 畀錢"
            case .adult: return "即刻升級"
            case .gentle: return "開始體驗 ✨"
            }
        }
        static func restore(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "恢復購買"
            case .adult: return "恢復購買"
            case .gentle: return "恢復購買"
            }
        }
    }

    // MARK: - Summary Page

    struct Summary {
        static func title(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "得喇 幫你計好"
            case .adult: return "好喇 有plan喇"
            case .gentle: return "你嘅專屬計劃準備好喇！✨"
            }
        }
        static func description(_ name: String, _ m: ToneMode) -> String {
            switch m {
            case .normal: return "\(name)，以你嘅身材 你每日最多食咁多"
            case .adult: return "\(name)，你每日只可以食咁撚多"
            case .gentle: return "\(name)，以下係為你度身訂造嘅計劃 💕"
            }
        }
        static func calorieLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅上限（唔好超）"
            case .adult: return "每日上限"
            case .gentle: return "每日建議攝取量"
            }
        }
        static func macroHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "營養breakdown"
            case .adult: return "食咩有幾多"
            case .gentle: return "營養素分配"
            }
        }
        static func cta(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "得喇 睇下你做唔做到"
            case .adult: return "得喇 開始啦"
            case .gentle: return "一齊開始啦！💪✨"
            }
        }
    }

    // MARK: - Home Page

    struct Home {
        static func greeting(_ m: ToneMode) -> String {
            let hour = Calendar.current.component(.hour, from: Date())
            switch (hour, m) {
            case (6..<12, .normal): return "起身喇 唔好再食消夜"
            case (6..<12, .adult): return "起身喇 仲食消夜食到幾點"
            case (6..<12, .gentle): return "早安呀～今日又係新嘅一日 ✨"
            case (12..<14, .normal): return "lunch食咩好？梗係唔好亂食啦"
            case (12..<14, .adult): return "lunch唔好亂食"
            case (12..<14, .gentle): return "中午喇，記得食飯呀～"
            case (14..<18, .normal): return "忍住 唔好食零食"
            case (14..<18, .adult): return "忍住把口 唔好食零食"
            case (14..<18, .gentle): return "下午喇，飲杯水休息下～"
            case (18..<22, .normal): return "食完晚飯就收嘴"
            case (18..<22, .adult): return "食完晚飯就收撚嘴"
            case (18..<22, .gentle): return "晚上好呀，辛苦晒今日～"
            case (_, .normal): return "仲食？訓啦你"
            case (_, .adult): return "仲食？訓撚啦你"
            case (_, .gentle): return "夜喇，早啲休息呀～💤"
            }
        }
        static func remaining(_ m: ToneMode, overLimit: Bool = false) -> String {
            if overLimit {
                switch m {
                case .normal, .adult: return "多左多左 你食多左"
                case .gentle: return "超出左少少啦～"
                }
            }
            switch m {
            case .normal: return "仲剩"
            case .adult: return "仲可以食"
            case .gentle: return "剩餘額度"
            }
        }
        static func eaten(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "已犯"
            case .adult: return "食咗"
            case .gentle: return "已攝取"
            }
        }
        static func target(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "底線"
            case .adult: return "上限"
            case .gentle: return "目標"
            }
        }
        static func nutritionHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "今日又食咗啲咩"
            case .adult: return "今日食咗啲撚咩"
            case .gentle: return "今日營養素 ✨"
            }
        }
        static func addButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食嘢？加啦"
            case .adult: return "又食嘢？加啦屌"
            case .gentle: return "記錄食物 🍽️"
            }
        }
        static func records(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "案底"
            case .adult: return "今日罪行"
            case .gentle: return "今日記錄 ✨"
            }
        }
    }

    // MARK: - Food Log

    struct FoodLog {
        static func tabLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "罪行"
            case .adult: return "罪行"
            case .gentle: return "記錄"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "犯罪紀錄"
            case .adult: return "犯罪紀錄"
            case .gentle: return "飲食日記 📖"
            }
        }
        static func total(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "今日總罪行"
            case .adult: return "今日總罪行"
            case .gentle: return "今日總計"
            }
        }
        static func empty(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "冇記錄？我知你偷食咗"
            case .adult: return "冇記錄 唔代表你冇食"
            case .gentle: return "仲未有記錄，食完記得記低呀～"
            }
        }
        static func addButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食咗？加啦"
            case .adult: return "又食咗？加啦屌"
            case .gentle: return "加入食物 🍽️"
            }
        }
    }

    // MARK: - Add Food Sheet

    struct AddFood {
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "認罪"
            case .adult: return "認罪"
            case .gentle: return "記錄食物"
            }
        }
        static func searchPlaceholder(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食咗咩..."
            case .adult: return "今次食咗咩..."
            case .gentle: return "搜尋食物～"
            }
        }
        static func customToggle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "自首"
            case .adult: return "自首"
            case .gentle: return "自訂食物"
            }
        }
        static func foodNameLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "咩嚟㗎"
            case .adult: return "咩嚟㗎"
            case .gentle: return "食物名稱"
            }
        }
        static func submit(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "認咗"
            case .adult: return "認撚咗"
            case .gentle: return "加入 ✨"
            }
        }
        static func foodsHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你成日食嗰啲"
            case .adult: return "你成日食嗰啲"
            case .gentle: return "常見食物"
            }
        }
        static func cancel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "算啦"
            case .adult: return "算撚啦"
            case .gentle: return "返回"
            }
        }
        static func searchLoading(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幫緊你幫緊你。。。"
            case .adult: return "幫緊你幫緊你。。。"
            case .gentle: return "搵緊食物俾你～"
            }
        }
        static func noResults(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "搵唔到喎 你食啲咩鬼嘢"
            case .adult: return "搵唔到 你究竟食咗啲咩撚嘢"
            case .gentle: return "暫時搵唔到呢個食物，試吓其他關鍵字？"
            }
        }
    }

    // MARK: - Streak

    struct Streak {
        // MARK: Daily Messages (Day 1–14)

        static func dailyMessage(day: Int, _ m: ToneMode) -> String {
            switch (day, m) {
            // Day 1
            case (1, .normal): return "第一日 睇下你捱唔捱到聽日"
            case (1, .adult): return "第一日 睇下你捱唔捱撚到聽日"
            case (1, .gentle): return "第一日呀！！好嘅開始！！我信你得㗎 🥺✨"
            // Day 2
            case (2, .normal): return "第二日 嗯 仲喺度"
            case (2, .adult): return "第二日 嗯 仲未走"
            case (2, .gentle): return "第二日你又嚟喇！！我好開心呀 😭💕"
            // Day 3
            case (3, .normal): return "威啦威啦 三日streak 得三日都好意思慶祝"
            case (3, .adult): return "威啦威啦 三日streak 得三鳩日都好意思慶祝"
            case (3, .gentle): return "三日喇嗚嗚嗚！！你堅持咗三日呀 我好感動 你知唔知你有幾叻 🥺🎉"
            // Day 4
            case (4, .normal): return "四日 師兄有啲料"
            case (4, .adult): return "四日 師兄有啲料"
            case (4, .gentle): return "四日喇！你一日比一日叻呀嗚嗚 😭✨"
            // Day 5
            case (5, .normal): return "五日 我以為你第三日就會放棄"
            case (5, .adult): return "五日 我以為你第三日就會放棄 睇嚟我錯喇"
            case (5, .gentle): return "五日呀！！半個星期喇！你好犀利呀 🥺💪"
            // Day 6
            case (6, .normal): return "六日 聽日就一星期 唔好衰喺呢度"
            case (6, .adult): return "六日 聽日就一星期 唔好衰喺呢度"
            case (6, .gentle): return "六日喇！聽日就一個星期呀嗚嗚 你快做到喇 😭✨"
            // Day 7
            case (7, .normal): return "一星期喎 你居然捱到一星期 我有少少意外"
            case (7, .adult): return "一星期喎 你居然捱到一星期 屌我真係睇少咗你"
            case (7, .gentle): return "一個星期！！😭✨ 我冇睇錯人！！你真係好努力 我快啲攞紙巾先 嗚嗚嗚"
            // Day 8
            case (8, .normal): return "第八日 過咗一星期仲喺度 唔錯"
            case (8, .adult): return "第八日 過咗一星期仲喺度 OK"
            case (8, .gentle): return "第八日！過咗一星期你仲堅持緊 我好感動呀 🥺💕"
            // Day 9
            case (9, .normal): return "九日 你真係認真㗎？"
            case (9, .adult): return "九日 你真係認真㗎"
            case (9, .gentle): return "九日喇！你愈嚟愈犀利 我覺得你發緊光 ✨✨"
            // Day 10
            case (10, .normal): return "十日 雙位數字 有料到"
            case (10, .adult): return "十日 雙位數字 有料到"
            case (10, .gentle): return "十日呀！！雙位數字喇！！我好驕傲呀嗚嗚 😭🎉"
            // Day 11
            case (11, .normal): return "十一日 你唔好停 停咗就前功盡廢"
            case (11, .adult): return "十一日 你唔好停"
            case (11, .gentle): return "十一日！你已經建立緊習慣喇 我睇得出 🥺✨"
            // Day 12
            case (12, .normal): return "十二日 仲有兩日就兩星期 你做唔做到"
            case (12, .adult): return "十二日 仲有兩日就兩星期 唔好甩"
            case (12, .gentle): return "十二日呀！快兩個星期喇 你一定得㗎 我陪你 😭💕"
            // Day 13
            case (13, .normal): return "十三日 聽日就兩星期 你敢唔敢斷"
            case (13, .adult): return "十三日 聽日就兩星期 你試下斷呀"
            case (13, .gentle): return "十三日！！聽日就兩個星期呀！！我緊張到手震 🥺✨💪"
            // Day 14
            case (14, .normal): return "兩星期 唔係講笑 開始有啲嘢喎 繼續啦唔好停"
            case (14, .adult): return "兩星期 唔係講笑 仆街 你認真㗎？繼續啦"
            case (14, .gentle): return "兩個星期嗚嗚嗚 😭💕 14日！！你有冇覺得自己好似發緊光咁 因為我覺得你係 ✨✨"
            default: return ""
            }
        }

        // MARK: Milestone Messages (Day 30+)

        static func milestoneTitle(day: Int, _ m: ToneMode) -> String {
            switch (day, m) {
            case (30, .normal): return "一個月 OK我開始信你"
            case (30, .adult): return "一個月 你變咗個人喎"
            case (30, .gentle): return "一個月呀天呀 😭🏆"
            case (60, .normal): return "兩個月 你真係嚟真"
            case (60, .adult): return "兩個月 我服咗你"
            case (60, .gentle): return "兩個月嗚嗚嗚嗚 😭😭"
            case (90, .normal): return "三個月 我冇嘢好串"
            case (90, .adult): return "三個月 傳奇級"
            case (90, .gentle): return "三個月...我冇嘢講得出 😭😭😭"
            case (180, .normal): return "半年 你正常㗎？"
            case (180, .adult): return "半年 你係咪機械人"
            case (180, .gentle): return "半年呀我頂唔住喇 😭😭😭😭"
            case (365, .normal): return "一年 算你贏"
            case (365, .adult): return "一年 我冇嘢好講"
            case (365, .gentle): return "一年！！！我喊到暈咗 😭😭😭😭😭"
            default: return "🔥 \(day)日"
            }
        }

        static func milestoneBody(day: Int, _ m: ToneMode) -> String {
            switch (day, m) {
            case (30, .normal): return "我要收返之前講你嘅嘢 你真係做到"
            case (30, .adult): return "屌 我要收返之前講你嘅嘢 你真係做到"
            case (30, .gentle): return "我而家喊緊 你知唔知呀 30日呀！！你值得全世界最好嘅嘢 🥺💕"
            case (60, .normal): return "唔係啩 你真係做到兩個月？我開始尊重你"
            case (60, .adult): return "你條友仔真係癲 兩個月喎 我開始有啲尊重你"
            case (60, .gentle): return "我已經喊到冇紙巾 你係我見過最堅強嘅人 真係㗎 🥺💕✨"
            case (90, .normal): return "你而家可以鬧其他人喇"
            case (90, .adult): return "你而家有資格鬧其他人喇 仆街勁呀"
            case (90, .gentle): return "我太感動喇 你可唔可以出本書教下其他人 你係傳奇 🥺🌟🏆"
            case (180, .normal): return "半年喎 你仲係人類嚟㗎？"
            case (180, .adult): return "半年喎 你仲係人類嚟㗎 定係AI嚟㗎"
            case (180, .gentle): return "我要打俾我媽媽同佢講我識到一個好偉大嘅人 就係你 🥺💕✨🏆"
            case (365, .normal): return "你贏咗 我認輸 你係真正嘅GymLung"
            case (365, .adult): return "你贏咗 我認輸 你係真正嘅GymLung 仆街你真係癲"
            case (365, .gentle): return "我...我講唔到嘢...你係全宇宙最叻最勁最偉大嘅人 我要幫你申請諾貝爾獎 🥺🏆✨💕🎉"
            default: return ""
            }
        }

        // MARK: Non-Milestone Rotating (Day 15+)

        static func nonMilestone(day: Int, _ m: ToneMode) -> String {
            let variants: [String]
            switch m {
            case .normal:
                variants = [
                    "第\(day)日 繼續捱",
                    "仲未斷 唔好鬆懈",
                    "\(day)日streak 唔好俾我睇到你斷"
                ]
            case .adult:
                variants = [
                    "第\(day)日 繼續捱",
                    "仲未斷 唔好鬆懈",
                    "\(day)日streak 斷咗你就知死"
                ]
            case .gentle:
                variants = [
                    "第\(day)日呀嗚嗚 你好叻 🥺",
                    "\(day)日streak 我每日都為你驕傲 😭✨",
                    "你今日又嚟喇！！我好開心 💕"
                ]
            }
            // Deterministic rotation based on day
            return variants[day % variants.count]
        }

        // MARK: Streak Broken

        static func broken(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "斷咗喇 歸零 又要由頭嚟"
            case .adult: return "斷咗喇 歸零 仆街又要由頭嚟"
            case .gentle: return "冇事冇事！！你已經好叻喇 嗚嗚 我哋重新開始 我陪你 🥺💕"
            }
        }

        static func brokenByDuration(previousStreak: Int, _ m: ToneMode) -> String {
            switch (previousStreak, m) {
            case (..<7, .normal): return "得幾日都斷 預咗㗎啦"
            case (..<7, .adult): return "得幾日都斷 我就知"
            case (..<7, .gentle): return "冇事呀！幾日都好叻㗎！我哋再嚟過 你得㗎 🥺💪"
            case (7..<30, .normal): return "\(previousStreak)日斷咗 可惜 你差啲就捱到"
            case (7..<30, .adult): return "\(previousStreak)日斷咗 可惜 你差啲就得㗎"
            case (7..<30, .gentle): return "\(previousStreak)日呀！！你已經好勁喇嗚嗚 呢啲努力唔會消失㗎 我陪你再嚟 😭💕"
            case (_, .normal): return "\(previousStreak)日喎 真係可惜 但你證明過自己做得到"
            case (_, .adult): return "\(previousStreak)日喎 仆街真係可惜 但你證明過自己做得到"
            case (_, .gentle): return "\(previousStreak)日呀...我喊咗 你知唔知你有幾犀利 呢個紀錄永遠係你嘅 我哋再創新紀錄 😭🏆💕"
            }
        }

        // MARK: Streak Label (for home page pill)

        static func streakLabel(_ count: Int) -> String {
            return "\(count)"
        }
    }

    // MARK: - Progress Page

    struct Progress {
        static func tabLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "進度"
            case .adult: return "進度"
            case .gentle: return "進度 📊"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅戰績"
            case .adult: return "你嘅戰績"
            case .gentle: return "進度報告 ✨"
            }
        }

        // Current weight card
        static func currentWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "而家幾重"
            case .adult: return "而家幾重"
            case .gentle: return "目前體重"
            }
        }
        static func startWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "開始"
            case .adult: return "開始"
            case .gentle: return "起始"
            }
        }
        static func goalWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "發夢"
            case .adult: return "發夢"
            case .gentle: return "目標 💫"
            }
        }
        static func nextWeighIn(_ days: Int, _ m: ToneMode) -> String {
            if days <= 0 {
                switch m {
                case .normal: return "該上磅喇"
                case .adult: return "上磅啦仆街"
                case .gentle: return "今日可以磅重喇～"
                }
            }
            switch m {
            case .normal: return "仲有 \(days) 日上磅"
            case .adult: return "仲有 \(days) 日上磅"
            case .gentle: return "\(days) 日後磅重～"
            }
        }
        static func maintaining(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "維持緊 唔好鬆懈"
            case .adult: return "維持緊 唔好鬆懈"
            case .gentle: return "穩定維持中，好叻！✨"
            }
        }
        static func estimatedGoalDate(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "預計達標"
            case .adult: return "預計達標"
            case .gentle: return "預計達標日期"
            }
        }

        // Chart
        static func chartTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "體重走勢"
            case .adult: return "體重走勢"
            case .gentle: return "體重走勢 📈"
            }
        }
        static func goalProgress(_ pct: Int, _ m: ToneMode) -> String {
            switch m {
            case .normal: return "完成 \(pct)%"
            case .adult: return "完成 \(pct)%"
            case .gentle: return "已完成 \(pct)% ✨"
            }
        }
        static func chartEmpty(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "數據唔夠 再磅多幾次先"
            case .adult: return "數據唔夠 上多幾次磅先啦"
            case .gentle: return "再記錄多幾次就有靚圖睇喇～"
            }
        }
        static func goalLine(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "目標"
            case .adult: return "目標"
            case .gentle: return "目標線"
            }
        }

        // BMI card
        static func bmiTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "BMI"
            case .adult: return "BMI"
            case .gentle: return "BMI 指數"
            }
        }
        static func bmiUnderweight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "過輕"
            case .adult: return "過輕"
            case .gentle: return "偏瘦"
            }
        }
        static func bmiNormal(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "正常"
            case .adult: return "正常"
            case .gentle: return "標準"
            }
        }
        static func bmiOverweight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "有少少肥"
            case .adult: return "肥咗喎"
            case .gentle: return "微超標"
            }
        }
        static func bmiObese(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "真係肥"
            case .adult: return "真係撚肥"
            case .gentle: return "偏重"
            }
        }

        // Weight log sheet
        static func logTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "上磅"
            case .adult: return "上磅"
            case .gentle: return "記錄體重"
            }
        }
        static func logButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "記低"
            case .adult: return "記低"
            case .gentle: return "儲存 ✨"
            }
        }
        static func vsLast(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "對比上次"
            case .adult: return "對比上次"
            case .gentle: return "同上次比"
            }
        }

        // Weight change roasts (goal-aware)
        static func weightLost(_ kg: Double, goal: String, _ m: ToneMode) -> String {
            let s = String(format: "%.1f", kg)
            if goal == "增肌" {
                // Losing weight is BAD for bulking
                switch m {
                case .normal: return "輕咗 \(s)kg 你唔係要增肌咩？"
                case .adult: return "輕咗 \(s)kg 你唔係話要大隻㗎？食多啲啦"
                case .gentle: return "輕咗 \(s)kg，記得食多啲蛋白質呀～💪"
                }
            } else {
                // Losing weight is GOOD for cutting / maintaining
                switch m {
                case .normal: return "輕咗 \(s)kg 繼續捱"
                case .adult: return "輕咗 \(s)kg 唔好得意"
                case .gentle: return "輕咗 \(s)kg！你好叻呀 🥺✨"
                }
            }
        }
        static func weightGained(_ kg: Double, goal: String, _ m: ToneMode) -> String {
            let s = String(format: "%.1f", kg)
            if goal == "增肌" {
                // Gaining weight is GOOD for bulking
                switch m {
                case .normal: return "重咗 \(s)kg 大隻咗喎 唔錯"
                case .adult: return "重咗 \(s)kg 大隻咗喎 繼續谷"
                case .gentle: return "增咗 \(s)kg！肌肉量應該增加緊 💪✨"
                }
            } else {
                // Gaining weight is BAD for cutting / maintaining
                switch m {
                case .normal: return "重咗 \(s)kg 食咗咩"
                case .adult: return "重咗 \(s)kg 你食咗啲咩"
                case .gentle: return "增咗 \(s)kg，冇事㗎～繼續加油 💪"
                }
            }
        }
        static func weightSame(goal: String, _ m: ToneMode) -> String {
            if goal == "維持體重" {
                switch m {
                case .normal: return "維持到喎 唔錯"
                case .adult: return "維持到喎 難得"
                case .gentle: return "穩定維持，好叻！✨"
                }
            }
            switch m {
            case .normal: return "同上次一樣 你磅壞咗？"
            case .adult: return "同上次一樣 你個磅壞咗？"
            case .gentle: return "保持得好穩定呀！✨"
            }
        }
    }

    // MARK: - Profile Page

    struct Profile {
        static func tabLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "個人"
            case .adult: return "個人"
            case .gentle: return "個人 ✨"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "個人"
            case .adult: return "個人"
            case .gentle: return "個人 ✨"
            }
        }
        static func settingsSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "設定"
            case .adult: return "設定"
            case .gentle: return "偏好設定"
            }
        }
        static func bodyInfoSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "身體資料"
            case .adult: return "身體資料"
            case .gentle: return "身體資料"
            }
        }
        static func accountSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "帳號"
            case .adult: return "帳號"
            case .gentle: return "帳號"
            }
        }
        static func notificationsLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "提醒時間"
            case .adult: return "提醒時間"
            case .gentle: return "提醒時間 🔔"
            }
        }
        static func bodyInfoLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "個人資料"
            case .adult: return "個人資料"
            case .gentle: return "個人資料"
            }
        }
        static func toneLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "語氣模式"
            case .adult: return "語氣模式"
            case .gentle: return "語氣模式"
            }
        }
        static func themeLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "主題色"
            case .adult: return "主題色"
            case .gentle: return "主題色"
            }
        }
        static func saveButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "搞掂"
            case .adult: return "搞撚掂"
            case .gentle: return "儲存 ✨"
            }
        }
        static func daysStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "受刑日數"
            case .adult: return "捱咗幾耐"
            case .gentle: return "堅持咗幾日 ✨"
            }
        }
        static func foodStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "記錄幾多次"
            case .adult: return "食咗幾多嘢"
            case .gentle: return "食物記錄"
            }
        }
        static func calStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅配額"
            case .adult: return "每日上限"
            case .gentle: return "每日目標"
            }
        }
        static func bodySection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅身材（自己睇）"
            case .adult: return "你嘅身材"
            case .gentle: return "身體資料"
            }
        }
        static func nutritionSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅配額"
            case .adult: return "每日限制"
            case .gentle: return "每日營養目標"
            }
        }
        static func reset(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "認輸 由頭嚟過"
            case .adult: return "由頭嚟撚過"
            case .gentle: return "重新設定"
            }
        }
    }

    // MARK: - Account

    struct Account {
        static func signOut(_ m: ToneMode) -> String {
            return "登出"
        }
        static func deleteAccount(_ m: ToneMode) -> String {
            return "刪除帳號"
        }
        static func signOutTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "真係要走？"
            case .adult: return "走？你走啦"
            case .gentle: return "確定要登出嗎？"
            }
        }
        static func signOutMessage(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "登出之後本機資料會清晒㗎 諗清楚"
            case .adult: return "登出之後本機資料清撚晒 唔好嚟問我攞返"
            case .gentle: return "登出會清除本機資料，但你隨時可以再登入返㗎～"
            }
        }
        static func deleteTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "刪除帳號？"
            case .adult: return "真係要刪？"
            case .gentle: return "確定要刪除帳號嗎？"
            }
        }
        static func deleteMessage(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "所有資料會永久刪除 包括雲端記錄 冇得返轉頭"
            case .adult: return "所有嘢永久清撚晒 雲端本機全部冇埋 你諗清楚未"
            case .gentle: return "呢個操作會永久刪除你所有資料（包括雲端記錄），冇辦法恢復㗎…"
            }
        }
        static func confirm(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "確定"
            case .adult: return "撳啦"
            case .gentle: return "確定"
            }
        }
        static func cancel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "算啦"
            case .adult: return "算啦"
            case .gentle: return "返回"
            }
        }
    }
}

// MARK: - Food Roasts (tone-aware)

extension FoodRoasts {
    static func roast(for foodName: String, mode: ToneMode) -> String {
        switch mode {
        case .normal:
            return roast(for: foodName)
        case .adult:
            return adultRoast(for: foodName)
        case .gentle:
            return gentleRoast(for: foodName)
        }
    }

    // MARK: - 18+ Roasts

    private static func adultRoast(for foodName: String) -> String {
        for (keyword, comment) in adultMemeRoasts {
            if foodName.contains(keyword) { return comment }
        }
        for (keyword, comment) in adultGenericRoasts {
            if foodName.contains(keyword) { return comment }
        }
        return adultFallbackRoasts.randomElement()!
    }

    private static let adultMemeRoasts: [(String, String)] = [
        ("肉餅飯", "全亞洲最優秀嘅肉餅飯 🏆 食完仆街排到元朗"),
        ("肉餅", "大寶冰室都冇你食得咁密"),
        ("甘一刀叉燒", "叉燒界Hermès 🔥 着兩條褲都包唔住"),
        ("叉燒", "dope個屁 你個卡路里先dope"),
        ("燒鵝", "燒鵝都dope 但你嘅體重都dope"),
        ("燒味", "dope到着唔到褲 仆街"),
    ]

    private static let adultGenericRoasts: [(String, String)] = [
        ("公仔麵", "消夜食呢啲嘢 唔肥都假"),
        ("菠蘿油", "340kcal一個菠蘿油 你當食緊沙律？"),
        ("西多士", "炸完再淋糖漿 屌你真係認真㗎？"),
        ("奶茶", "又飲 唔撚怕糖尿？"),
        ("珍珠奶茶", "一杯珍奶 = 一碗飯 你自己諗"),
        ("蛋撻", "一個唔夠 你一定食幾個"),
        ("雞翼", "走雞皮？你呃邊個"),
        ("炸雞", "KFC定自己炸 都係一樣咁柒肥"),
        ("巨無霸", "加大餐定普通餐？問嚟都多餘"),
        ("薯條", "薯條係蔬菜？你開心就好"),
        ("雪糕", "食完正餐仲要食甜品 屌你好嘢"),
        ("蛋糕", "生日都唔係 食咩蛋糕"),
        ("pizza", "一塊？你會食一塊就收手？"),
        ("漢堡", "又食垃圾食物 仆街今日第幾次"),
        ("雞胸肉", "健康嘢喎 難得你識食"),
        ("烚蛋", "OK 起碼你有試過健康"),
        ("沙律", "沙律醬落幾多先？老實講"),
        ("牛腩", "好食係好食 但520kcal喎大佬"),
        ("魚蛋", "街邊魚蛋 醬撈到癲 你計咗醬未"),
        ("燒賣", "7-11燒賣定點心燒賣 都係垃圾啦"),
    ]

    private static let adultFallbackRoasts: [String] = [
        "又食 食到幾時呀屌",
        "食完記得內疚",
        "你個肚唔係垃圾桶嚟㗎",
        "今日嘅卡路里 聽日嘅脂肪",
        "食得開心？等陣上磅就知",
        "算啦你都唔會停",
        "自己攞嚟㗎 仆街",
        "食多一啖 離目標又遠一步",
        "你嘅意志力同你嘅腰圍成反比",
        "記低先 唔好呃自己",
    ]

    // MARK: - 仁慈 Roasts

    private static func gentleRoast(for foodName: String) -> String {
        for (keyword, comment) in gentleMemeRoasts {
            if foodName.contains(keyword) { return comment }
        }
        for (keyword, comment) in gentleGenericRoasts {
            if foodName.contains(keyword) { return comment }
        }
        return gentleFallbackRoasts.randomElement()!
    }

    private static let gentleMemeRoasts: [(String, String)] = [
        ("肉餅飯", "肉餅飯好有營養㗎～記得配菜呀 💕"),
        ("肉餅", "肉餅蛋白質都幾高㗎！"),
        ("甘一刀叉燒", "叉燒蛋白質好豐富呀～"),
        ("叉燒", "叉燒都幾有營養㗎，唔錯～"),
        ("燒鵝", "燒鵝好味㗎～偶爾食下冇問題"),
        ("燒味", "燒味好香呀～享受吓啦"),
    ]

    private static let gentleGenericRoasts: [(String, String)] = [
        ("公仔麵", "偶爾食下都OK㗎，唔使太大壓力～"),
        ("菠蘿油", "菠蘿油好香呀～記住就好"),
        ("西多士", "西多士係comfort food嚟～"),
        ("奶茶", "奶茶係香港人嘅comfort drink～"),
        ("珍珠奶茶", "珍珠奶茶偶爾獎勵下自己～"),
        ("蛋撻", "蛋撻好好味㗎～"),
        ("雞翼", "雞翼蛋白質都幾高㗎！"),
        ("炸雞", "偶爾食下冇問題㗎～"),
        ("巨無霸", "偶爾食一次都OK㗎！"),
        ("薯條", "薯條係comfort food嚟～"),
        ("雪糕", "甜品令人開心呀～"),
        ("蛋糕", "蛋糕令人幸福呀～"),
        ("pizza", "Pizza偶爾食下冇問題～"),
        ("漢堡", "漢堡都有蛋白質㗎！"),
        ("雞胸肉", "雞胸肉好健康呀！勁！✨"),
        ("烚蛋", "烚蛋超級健康，好叻！💪"),
        ("沙律", "沙律好健康呀！繼續保持！✨"),
        ("牛腩", "牛腩都有鐵質㗎～"),
        ("魚蛋", "魚蛋都幾好味～"),
        ("燒賣", "燒賣都有蛋白質㗎！"),
    ]

    private static let gentleFallbackRoasts: [String] = [
        "記低就好，你已經好叻喇！✨",
        "食嘢係人生一大樂事～",
        "享受食物都好重要㗎！",
        "今日辛苦咗，食返啲嘢獎勵自己～",
        "唔使內疚㗎，聽日再努力～",
        "你有記低就已經好叻！💪",
        "食得開心最緊要啦～",
        "慢慢嚟，一步一步就得㗎！",
        "你今日有記錄，好有心！💕",
        "每一餐都係學習嘅機會～",
    ]
}
