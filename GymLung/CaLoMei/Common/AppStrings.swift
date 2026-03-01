//
//  AppStrings.swift
//  CaLoMei
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
            case .twGanHua: return "專講幹話的熱量計算 app"
            case .twAma: return "阿嬤叫你不要再吃了啦"
            case .twYanShi: return "...又一個減肥 app，然後呢"
            }
        }
        static func feature1(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "影相就知你食咗幾多垃圾"
            case .adult: return "影相就知你偷食咗啲咩"
            case .gentle: return "影相就可以記錄飲食～"
            case .twGanHua: return "拍照就能知道你吃了什麼，科技真偉大"
            case .twAma: return "拍個照就幫你記，阿嬤都會用～"
            case .twYanShi: return "拍照記錄...反正吃都吃了"
            }
        }
        static func feature2(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幫你數下你食咗幾多嘢"
            case .adult: return "記低你每日嘅罪行"
            case .gentle: return "輕鬆追蹤每日營養 💪"
            case .twGanHua: return "幫你算熱量，雖然算了你也不一定會少吃"
            case .twAma: return "幫你算算每天吃了多少，阿嬤幫你看著～"
            case .twYanShi: return "追蹤每日營養...然後呢"
            }
        }
        static func feature3(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "香港垃圾食物資料庫 啱晒你"
            case .adult: return "收錄晒你成日食嘅嘢"
            case .gentle: return "超多香港地道食物資料庫～"
            case .twGanHua: return "台灣食物資料庫，從珍奶到鹹酥雞都有"
            case .twAma: return "阿嬤知道的食物通通都有啦～"
            case .twYanShi: return "食物資料庫...收錄了各種讓人發胖的東西"
            }
        }
        static func skipButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "唔登入直接用"
            case .adult: return "懶登入直接用"
            case .gentle: return "先體驗一下～"
            case .twGanHua: return "不登入直接用，反正差別不大"
            case .twAma: return "先試試看嘛～"
            case .twYanShi: return "...隨便吧"
            }
        }
    }

    // MARK: - Welcome Page

    struct Welcome {
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你個Gym Lung Bro已經睇唔過眼\n要親自幫你計卡路里"
            case .adult: return "專屌你食垃圾嘅 app"
            case .gentle: return "你嘅健康小幫手 ✨"
            case .twGanHua: return "一個會跟你講幹話的熱量 app"
            case .twAma: return "阿嬤幫你顧健康啦～"
            case .twYanShi: return "...歡迎來到這個毫無意義的旅程"
            }
        }
        static func nameQuestion(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "叫咩名"
            case .adult: return "叫咩名"
            case .gentle: return "你叫咩名呀～"
            case .twGanHua: return "你叫什麼"
            case .twAma: return "你叫什麼名字呀？"
            case .twYanShi: return "...叫什麼都無所謂"
            }
        }
        static func namePlaceholder(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "打啦"
            case .adult: return "快啲打啦屌"
            case .gentle: return "打你個靚名出嚟～"
            case .twGanHua: return "打字，這個你應該會吧"
            case .twAma: return "打你的名字給阿嬤看～"
            case .twYanShi: return "...隨便打"
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
            case .twGanHua: return "生理性別"
            case .twAma: return "你是男生還女生呀？"
            case .twYanShi: return "...性別"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要嚟計你有幾肥"
            case .adult: return "唔係八卦 計數要用"
            case .gentle: return "我哋需要呢個資料先幫到你 💪"
            case .twGanHua: return "這會影響基礎代謝率的計算，是科學"
            case .twAma: return "阿嬤需要知道才能幫你算啦～"
            case .twYanShi: return "...要算熱量用的，不是八卦"
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
            case .twGanHua: return "出生日期"
            case .twAma: return "你幾歲啦？生日什麼時候？"
            case .twYanShi: return "...生日，又老一歲的提醒"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "唔使扮後生 我計到㗎"
            case .adult: return "生日唔會呃人"
            case .gentle: return "每個生日都值得慶祝 🎂"
            case .twGanHua: return "年齡會影響代謝率，這是事實不是歧視"
            case .twAma: return "阿嬤不會嫌你老啦～"
            case .twYanShi: return "...年齡只是數字，跟體重一樣殘酷的數字"
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
            case .twGanHua: return "身高體重"
            case .twAma: return "你多高多重呀？"
            case .twYanShi: return "...身高體重，殘酷的數字"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "等我睇下你有幾肥"
            case .adult: return "等我睇下你有幾撚肥"
            case .gentle: return "呢個幫我哋更加了解你 💕"
            case .twGanHua: return "讓我們用科學的方式評估你的身材"
            case .twAma: return "阿嬤看看你有沒有好好吃飯～"
            case .twYanShi: return "...讓我看看現實有多殘忍"
            }
        }
        static func bmiCategory(_ bmi: Double, _ m: ToneMode) -> String {
            switch (bmi, m) {
            case (..<18.5, .normal): return "排骨精"
            case (..<18.5, .adult): return "食撚多啲啦瘦成咁"
            case (..<18.5, .gentle): return "偏瘦少少，記得多食啲呀～"
            case (..<18.5, .twGanHua): return "根據BMI，你偏瘦，但這不代表你健康"
            case (..<18.5, .twAma): return "瘦成這樣，阿嬤看了會心疼啦"
            case (..<18.5, .twYanShi): return "偏瘦...不過體重正不正常也不影響人生的虛無"
            case (18.5..<24, .normal): return "算啦 唔肥"
            case (18.5..<24, .adult): return "OK啦 未算太柒"
            case (18.5..<24, .gentle): return "好標準呀！繼續保持 ✨"
            case (18.5..<24, .twGanHua): return "BMI正常，恭喜你是個普通人"
            case (18.5..<24, .twAma): return "不錯不錯，繼續保持，阿嬤放心了"
            case (18.5..<24, .twYanShi): return "正常...在這個不正常的世界裡"
            case (24..<28, .normal): return "姐係有少少肥咁 少少🤏"
            case (24..<28, .adult): return "屌 真係肥咗喎"
            case (24..<28, .gentle): return "有少少超標，冇問題㗎～"
            case (24..<28, .twGanHua): return "根據統計，你目前屬於微胖，但拒絕承認也是一種自由"
            case (24..<28, .twAma): return "有點胖了喔，少吃一點鹹酥雞啦"
            case (24..<28, .twYanShi): return "有點超標...不過人生也沒什麼不超標的"
            case (_, .normal): return "...兄弟你認真㗎？"
            case (_, .adult): return "仆街 你認真㗎？"
            case (_, .gentle): return "我哋一齊努力，一定得㗎！💪"
            case (_, .twGanHua): return "你的BMI已經超出正常範圍，這是一個事實"
            case (_, .twAma): return "怎麼胖成這樣！都不聽阿嬤的話"
            case (_, .twYanShi): return "...加油吧，雖然加了也不一定會比較好"
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
            case .twGanHua: return "你有在運動嗎"
            case .twAma: return "你平常有沒有在動呀？"
            case .twYanShi: return "...運動，一個美好的幻想"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "定係淨係識攤喺度"
            case .adult: return "定係淨係識攤喺度做廢柒"
            case .gentle: return "冇做都唔緊要㗎，慢慢嚟～"
            case .twGanHua: return "還是只會躺在沙發上滑手機"
            case .twAma: return "沒運動也沒關係啦，阿嬤不怪你～"
            case .twYanShi: return "...不動也是一種生活方式"
            }
        }
        static func levelSubtitle(_ title: String, _ m: ToneMode) -> String {
            switch (title, m) {
            case ("好少運動", .normal): return "淨係識躺平"
            case ("好少運動", .adult): return "躺平等死"
            case ("好少運動", .gentle): return "休息都係一種充電～"
            case ("好少運動", .twGanHua): return "根據研究，你的運動量跟樹懶差不多"
            case ("好少運動", .twAma): return "都不動的喔？阿嬤幫你擔心啦～"
            case ("好少運動", .twYanShi): return "...躺平，至少很誠實"
            case ("輕度運動", .normal): return "行去買珍奶都計"
            case ("輕度運動", .adult): return "行去買珍奶都算？"
            case ("輕度運動", .gentle): return "有郁動就好好呀！"
            case ("輕度運動", .twGanHua): return "走去買手搖飲也算運動的話"
            case ("輕度運動", .twAma): return "有動就好啦，慢慢來～"
            case ("輕度運動", .twYanShi): return "...聊勝於無吧"
            case ("中等運動", .normal): return "起碼有出過汗"
            case ("中等運動", .adult): return "起碼出過汗"
            case ("中等運動", .gentle): return "好叻呀，繼續保持！✨"
            case ("中等運動", .twGanHua): return "至少有流過汗，不錯喔"
            case ("中等運動", .twAma): return "有在運動喔！阿嬤很欣慰～"
            case ("中等運動", .twYanShi): return "...還行吧"
            case ("高強度運動", .normal): return "你嚟呢度做咩"
            case ("高強度運動", .adult): return "你嚟呢度做鳩咩"
            case ("高強度運動", .gentle): return "勁呀你！超級自律！💪"
            case ("高強度運動", .twGanHua): return "你來這裡幹嘛，你不需要這個 app"
            case ("高強度運動", .twAma): return "這麼厲害！阿嬤驕傲死了～"
            case ("高強度運動", .twYanShi): return "...這麼努力，然後呢"
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
            case .twGanHua: return "你的目標是什麼"
            case .twAma: return "你想怎樣呀？"
            case .twYanShi: return "...目標，如果還有的話"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "老實講 唔好呃自己"
            case .adult: return "講清楚 唔好兜"
            case .gentle: return "每個目標都值得被支持 💕"
            case .twGanHua: return "老實說，不要騙自己"
            case .twAma: return "跟阿嬤說實話喔～"
            case .twYanShi: return "...選一個吧，反正結果都差不多"
            }
        }
        static func goalSubtitle(_ goal: String, _ m: ToneMode) -> String {
            switch (goal, m) {
            case ("減脂", .normal): return "係時候面對現實"
            case ("減脂", .adult): return "係時候面對現實啦"
            case ("減脂", .gentle): return "你已經好靚，但可以更好～"
            case ("減脂", .twGanHua): return "根據統計，80%的人減脂失敗，加油"
            case ("減脂", .twAma): return "少吃一點就瘦了啦，阿嬤教你～"
            case ("減脂", .twYanShi): return "...減脂，一場注定痛苦的旅程"
            case ("維持體重", .normal): return "即係覺得自己OK㗎？"
            case ("維持體重", .adult): return "即係覺得自己OK㗎？真㗎？"
            case ("維持體重", .gentle): return "保持現狀都好叻㗎！"
            case ("維持體重", .twGanHua): return "所以你覺得現在這樣OK？好的"
            case ("維持體重", .twAma): return "維持就好啦，不要亂減～"
            case ("維持體重", .twYanShi): return "...維持現狀，人生最安全的選擇"
            case ("增肌", .normal): return "排骨想變大隻"
            case ("增肌", .adult): return "排骨想變大隻"
            case ("增肌", .gentle): return "增肌之路，一齊行！💪"
            case ("增肌", .twGanHua): return "想變壯？先確定你吃得夠多"
            case ("增肌", .twAma): return "要長肉喔！阿嬤多煮一點給你吃～"
            case ("增肌", .twYanShi): return "...增肌，把痛苦換成另一種痛苦"
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
            case ("減脂", .twGanHua): return "你想瘦到多少"
            case ("減脂", .twAma): return "想瘦到幾公斤呀？"
            case ("減脂", .twYanShi): return "...想瘦到多少，如果可以的話"
            case ("增肌", .normal): return "想大隻到幾多"
            case ("增肌", .adult): return "想大隻到幾撚多"
            case ("增肌", .twGanHua): return "你想增重到多少"
            case ("增肌", .twAma): return "想長到幾公斤呀？"
            case ("增肌", .twYanShi): return "...想增到多少，夢想還是要有的"
            case ("維持體重", .normal): return "維持喺邊度"
            case ("維持體重", .adult): return "維持喺邊度"
            case ("維持體重", .twGanHua): return "維持在哪裡"
            case ("維持體重", .twAma): return "維持現在這樣就好啦～"
            case ("維持體重", .twYanShi): return "...維持，最不費力的選擇"
            case (_, .gentle): return "你嘅理想體重～"
            default: return "目標體重"
            }
        }
        static func subtitleMaintain(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "滿意自己？好自信喎"
            case .adult: return "咁你幾滿意自己喎"
            case .gentle: return "好欣賞你接受自己 💕"
            case .twGanHua: return "對自己滿意？這很罕見欸"
            case .twAma: return "這樣就好啦，阿嬤覺得你很好～"
            case .twYanShi: return "...滿意自己，難得的心態"
            }
        }
        static func subtitle(_ goal: String, _ m: ToneMode) -> String {
            switch (goal, m) {
            case ("減脂", .normal): return "揀個數字 realistic啲"
            case ("減脂", .adult): return "講個合理數字 唔好發夢"
            case ("減脂", .twGanHua): return "選個合理的數字，不要太離譜"
            case ("減脂", .twAma): return "不要減太多喔，健康最重要啦～"
            case ("減脂", .twYanShi): return "...選個數字吧，反正你可能也達不到"
            case ("增肌", .normal): return "想增幾多 唔好離地"
            case ("增肌", .adult): return "想增到幾重 唔好痴心妄想"
            case ("增肌", .twGanHua): return "想增多少，請務實一點"
            case ("增肌", .twAma): return "慢慢來不要急啦～"
            case ("增肌", .twYanShi): return "...選個數字，夢總是要做的"
            case (_, .gentle): return "設定一個舒服嘅目標就好～"
            default: return "揀個數字 realistic啲"
            }
        }
        static func currentLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "現實"
            case .adult: return "而家嘅你"
            case .gentle: return "而家嘅你 ✨"
            case .twGanHua: return "現實"
            case .twAma: return "現在的你"
            case .twYanShi: return "殘酷的現實"
            }
        }
        static func targetLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "理想"
            case .adult: return "理想"
            case .gentle: return "未來嘅你 💫"
            case .twGanHua: return "理想"
            case .twAma: return "目標"
            case .twYanShi: return "遙遠的夢"
            }
        }
        static func gainLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要增"
            case .adult: return "要增"
            case .gentle: return "需要調整"
            case .twGanHua: return "需增加"
            case .twAma: return "要多吃"
            case .twYanShi: return "要增"
            }
        }
        static func lossLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "要減"
            case .adult: return "要減"
            case .gentle: return "需要調整"
            case .twGanHua: return "需減少"
            case .twAma: return "要少吃"
            case .twYanShi: return "要減"
            }
        }
        static func timeEstimate(_ weeks: Int, _ m: ToneMode) -> String {
            switch m {
            case .normal: return "大約 \(weeks) 星期（你忍唔忍到就另計）"
            case .adult: return "大約 \(weeks) 星期（如果你忍到嘴）"
            case .gentle: return "大約 \(weeks) 星期，慢慢嚟唔使急～"
            case .twGanHua: return "大約 \(weeks) 週，前提是你真的有在執行"
            case .twAma: return "大約 \(weeks) 週，慢慢來不要急啦～"
            case .twYanShi: return "大約 \(weeks) 週...如果你撐得住的話"
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
            case .twGanHua: return "你通常幾點吃飯"
            case .twAma: return "你平常幾點吃飯呀？"
            case .twYanShi: return "...吃飯時間，人生少數的期待"
            }
        }
        static func subtitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "等我到時捉你偷食"
            case .adult: return "等我到時提你認罪"
            case .gentle: return "我會溫馨提醒你～"
            case .twGanHua: return "到時候會提醒你，雖然你大概會忽略"
            case .twAma: return "阿嬤到時候提醒你吃飯喔～"
            case .twYanShi: return "...到時候會通知你，別理我也行"
            }
        }
        static func breakfastLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "早餐"
            case .adult: return "早餐"
            case .gentle: return "早餐 🌅"
            case .twGanHua: return "早餐"
            case .twAma: return "早餐"
            case .twYanShi: return "早餐"
            }
        }
        static func lunchLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "午餐"
            case .adult: return "午餐"
            case .gentle: return "午餐 ☀️"
            case .twGanHua: return "午餐"
            case .twAma: return "午餐"
            case .twYanShi: return "午餐"
            }
        }
        static func dinnerLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "晚餐"
            case .adult: return "晚餐"
            case .gentle: return "晚餐 🌙"
            case .twGanHua: return "晚餐"
            case .twAma: return "晚餐"
            case .twYanShi: return "晚餐"
            }
        }
        static func notificationHint(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "走唔甩㗎 到時會捉你"
            case .adult: return "到時會提你認罪"
            case .gentle: return "我會喺呢啲時間溫馨提醒你～"
            case .twGanHua: return "時間到了就會通知你，跑不掉的"
            case .twAma: return "阿嬤會準時提醒你的～"
            case .twYanShi: return "...會提醒你，雖然提醒了也不一定有用"
            }
        }
    }

    // MARK: - Paywall Page

    struct Paywall {
        static func title(for trigger: PaywallTrigger, _ r: Region) -> String {
            switch trigger {
            case .onboarding(let goal, _):
                if goal == "增肌" {
                    return r == .hk ? "想大隻？升級啦" : "想變壯？升級吧"
                }
                return r == .hk ? "想瘦？升級啦" : "想瘦？升級吧"
            case .scanLimit(let gender):
                if r == .tw { return "長大了吧" }
                return gender == "女" ? "大個女啦" : "大個仔啦"
            case .toneLock:
                return r == .hk ? "想聽更多嘢？" : "想聽更多？"
            case .weightLog:
                return r == .hk ? "想知自己進步幾多？" : "想知道自己進步多少？"
            }
        }
        static func subtitle(for trigger: PaywallTrigger, _ r: Region) -> String {
            switch trigger {
            case .onboarding(let goal, _):
                if goal == "增肌" {
                    return r == .hk ? "增肌要食啱嘢 唔track點知食夠未" : "增肌要吃對東西 不追蹤怎麼知道夠不夠"
                }
                return r == .hk ? "免費版夠你用 但你瘦唔到唔好怪我" : "免費版能用 但你瘦不下來不要怪我"
            case .scanLimit:
                return r == .hk ? "自己嘅AI Tokens自己俾啦" : "自己的AI Tokens自己付吧"
            case .toneLock:
                return r == .hk ? "升級解鎖全部語氣 想點串就點串" : "升級解鎖所有語氣 想怎麼嘴就怎麼嘴"
            case .weightLog:
                return r == .hk ? "升級先可以記錄體重 睇晒你嘅進度" : "升級才能記錄體重 追蹤你的所有進度"
            }
        }
        static func feature1(_ r: Region) -> String {
            switch r {
            case .hk: return "AI幫你認食物 唔使自己打"
            case .tw: return "AI拍照辨識食物 比你自己認還準"
            }
        }
        static func feature2(_ r: Region) -> String {
            switch r {
            case .hk: return "體重追蹤同營養報告 睇晒你嘅進度"
            case .tw: return "體重追蹤跟營養報告 用數據看你的起伏"
            }
        }
        static func feature3(_ r: Region) -> String {
            switch r {
            case .hk: return "解鎖全部語氣模式 想點串就點串"
            case .tw: return "解鎖所有語氣模式 讓你被各種方式嘴"
            }
        }
        static func feature4(_ r: Region) -> String {
            switch r {
            case .hk: return "無限掃描 食幾多影幾多"
            case .tw: return "無限掃描 讓AI無限次審判你的食物"
            }
        }
        static func annualLabel(_ r: Region) -> String {
            switch r {
            case .hk: return "年費（識計數）"
            case .tw: return "年費（會算數的都選這個）"
            }
        }
        static func annualSubtitle(_ r: Region) -> String {
            switch r {
            case .hk: return "飲少6杯廢水就搞掂一年"
            case .tw: return "少喝6杯珍奶就一年了"
            }
        }
        static func monthlyLabel(_ r: Region) -> String {
            switch r {
            case .hk: return "月費（貴啲㗎）"
            case .tw: return "月費（比較貴 但你開心就好）"
            }
        }
        static func monthlySubtitle(_ r: Region) -> String {
            switch r {
            case .hk: return "每個月飲少杯廢水咪得囉"
            case .tw: return "每個月少喝杯珍奶而已"
            }
        }
        static func saveBadge(_ r: Region) -> String {
            switch r {
            case .hk: return "識揀"
            case .tw: return "聰明人的選擇"
            }
        }
        static func cta(_ r: Region) -> String {
            switch r {
            case .hk: return "好啦 畀錢"
            case .tw: return "好啦 付錢吧"
            }
        }
        static func restore(_ r: Region) -> String {
            return "恢復購買"
        }

        // MARK: - Trial-Aware Strings

        static func ctaTrial(_ r: Region) -> String {
            switch r {
            case .hk: return "免費試3日"
            case .tw: return "免費試用3天"
            }
        }

        static func subtitleTrial(for trigger: PaywallTrigger, _ r: Region) -> String {
            switch trigger {
            case .scanLimit:
                return r == .hk ? "自己嘅AI Tokens自己俾啦" : "自己的AI Tokens自己付吧"
            default:
                return r == .hk ? "3日免費試用 唔啱就cancel 唔收你錢" : "3天免費試用 不喜歡就取消 不收你錢"
            }
        }

        static func trialBadge(_ r: Region) -> String {
            switch r {
            case .hk: return "免費試3日"
            case .tw: return "免費試3天"
            }
        }

        static func annualPriceWithTrial(_ price: String, _ r: Region) -> String {
            switch r {
            case .hk: return "3日免費 之後 \(price)/年"
            case .tw: return "3天免費 之後 \(price)/年"
            }
        }

        static func monthlyPriceWithTrial(_ price: String, _ r: Region) -> String {
            switch r {
            case .hk: return "3日免費 之後 \(price)/月"
            case .tw: return "3天免費 之後 \(price)/月"
            }
        }

        static func timelineToday(_ r: Region) -> String {
            switch r {
            case .hk: return "即刻解鎖全部功能"
            case .tw: return "立刻解鎖所有功能"
            }
        }

        static func timelineReminder(_ r: Region) -> String {
            switch r {
            case .hk: return "我哋會提你"
            case .tw: return "我們會提醒你"
            }
        }

        static func timelineBilling(_ r: Region) -> String {
            switch r {
            case .hk: return "開始收費 隨時cancel"
            case .tw: return "開始收費 隨時取消"
            }
        }

        static func trialDisclosure(_ r: Region) -> String {
            switch r {
            case .hk: return "免費試用期後將自動續訂。可隨時喺設定中取消訂閱。"
            case .tw: return "免費試用結束後將自動續訂。可隨時在設定中取消訂閱。"
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
            case .twGanHua: return "算好了，看你能不能做到"
            case .twAma: return "阿嬤幫你規劃好了喔～"
            case .twYanShi: return "...計劃好了，然後呢"
            }
        }
        static func description(_ name: String, _ goal: String, _ m: ToneMode) -> String {
            if goal == "增肌" {
                switch m {
                case .normal: return "\(name)，想大隻就要食夠咁多"
                case .adult: return "\(name)，想大隻就食撚夠佢"
                case .gentle: return "\(name)，以下係為你度身訂造嘅計劃 💕"
                case .twGanHua: return "\(name)，想增肌就要吃夠這些量"
                case .twAma: return "\(name)，要長肉就要多吃一點喔～"
                case .twYanShi: return "\(name)...以下是你的計劃，能不能做到是另一回事"
                }
            } else {
                switch m {
                case .normal: return "\(name)，以你嘅身材 你每日最多食咁多"
                case .adult: return "\(name)，你每日只可以食咁撚多"
                case .gentle: return "\(name)，以下係為你度身訂造嘅計劃 💕"
                case .twGanHua: return "\(name)，以你的身材，每天最多只能吃這些"
                case .twAma: return "\(name)，阿嬤幫你算好了，照著吃就對了～"
                case .twYanShi: return "\(name)...這是你的每日上限，超過了也不意外"
                }
            }
        }
        static func calorieLabel(_ goal: String, _ m: ToneMode) -> String {
            if goal == "增肌" {
                switch m {
                case .normal: return "你嘅目標（食夠佢）"
                case .adult: return "每日目標 食唔夠你走"
                case .gentle: return "每日建議攝取量"
                case .twGanHua: return "你的目標（吃夠它）"
                case .twAma: return "每天要吃到這些喔～"
                case .twYanShi: return "每日目標...吃不到也正常"
                }
            } else {
                switch m {
                case .normal: return "你嘅上限（唔好超）"
                case .adult: return "每日上限"
                case .gentle: return "每日建議攝取量"
                case .twGanHua: return "你的上限（不要超過）"
                case .twAma: return "每天不要超過這個量喔～"
                case .twYanShi: return "每日上限...超過了也不會怎樣，就是胖"
                }
            }
        }
        static func macroHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "營養breakdown"
            case .adult: return "食咩有幾多"
            case .gentle: return "營養素分配"
            case .twGanHua: return "營養素分配，一個你大概不會看的表"
            case .twAma: return "營養分配"
            case .twYanShi: return "營養素...又是一堆數字"
            }
        }
        static func cta(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "得喇 睇下你做唔做到"
            case .adult: return "得喇 開始啦"
            case .gentle: return "一齊開始啦！💪✨"
            case .twGanHua: return "好了，看你能撐多久"
            case .twAma: return "開始吧，阿嬤陪你～"
            case .twYanShi: return "...開始吧，雖然結局可能一樣"
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
            case (6..<12, .twGanHua): return "早安，根據統計，早餐是最容易被跳過的一餐"
            case (6..<12, .twAma): return "起床了喔？阿嬤幫你準備蛋餅了～"
            case (6..<12, .twYanShi): return "...早安，又是充滿熱量的一天"
            case (12..<14, .normal): return "lunch食咩好？梗係唔好亂食啦"
            case (12..<14, .adult): return "lunch唔好亂食"
            case (12..<14, .gentle): return "中午喇，記得食飯呀～"
            case (12..<14, .twGanHua): return "中午了，便當跟滷肉飯你選一個"
            case (12..<14, .twAma): return "中午了，有沒有好好吃飯呀？"
            case (12..<14, .twYanShi): return "...午餐，又要面對選擇的痛苦"
            case (14..<18, .normal): return "忍住 唔好食零食"
            case (14..<18, .adult): return "忍住把口 唔好食零食"
            case (14..<18, .gentle): return "下午喇，飲杯水休息下～"
            case (14..<18, .twGanHua): return "下午了，離手搖飲遠一點"
            case (14..<18, .twAma): return "下午了，喝杯水，不要喝飲料喔～"
            case (14..<18, .twYanShi): return "...下午了，什麼都不想做"
            case (18..<22, .normal): return "食完晚飯就收嘴"
            case (18..<22, .adult): return "食完晚飯就收撚嘴"
            case (18..<22, .gentle): return "晚上好呀，辛苦晒今日～"
            case (18..<22, .twGanHua): return "晚餐吃完就停，夜市就別去了"
            case (18..<22, .twAma): return "晚上了，吃完飯就不要再吃了喔～"
            case (18..<22, .twYanShi): return "...晚上了，今天也快結束了"
            case (_, .normal): return "仲食？訓啦你"
            case (_, .adult): return "仲食？訓撚啦你"
            case (_, .gentle): return "夜喇，早啲休息呀～💤"
            case (_, .twGanHua): return "這個時間還在吃東西，你的消化系統還在加班"
            case (_, .twAma): return "這麼晚了還不睡？不要吃宵夜啦！"
            case (_, .twYanShi): return "...深夜了，吃不吃都一樣空虛"
            }
        }
        static func remaining(_ m: ToneMode, overLimit: Bool = false) -> String {
            if overLimit {
                switch m {
                case .normal, .adult: return "多左多左 你食多左"
                case .gentle: return "超出左少少啦～"
                case .twGanHua: return "超標了，這是一個數學問題"
                case .twAma: return "吃太多了啦！"
                case .twYanShi: return "...超標了，意料之中"
                }
            }
            switch m {
            case .normal: return "仲剩"
            case .adult: return "仲可以食"
            case .gentle: return "剩餘額度"
            case .twGanHua: return "還剩"
            case .twAma: return "還可以吃"
            case .twYanShi: return "剩餘"
            }
        }
        static func eaten(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "已犯"
            case .adult: return "食咗"
            case .gentle: return "已攝取"
            case .twGanHua: return "已攝取"
            case .twAma: return "吃了"
            case .twYanShi: return "已吃"
            }
        }
        static func target(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "底線"
            case .adult: return "上限"
            case .gentle: return "目標"
            case .twGanHua: return "上限"
            case .twAma: return "目標"
            case .twYanShi: return "上限"
            }
        }
        static func nutritionHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "今日又食咗啲咩"
            case .adult: return "今日食咗啲撚咩"
            case .gentle: return "今日營養素 ✨"
            case .twGanHua: return "今天你又吃了什麼"
            case .twAma: return "今天的營養"
            case .twYanShi: return "今日營養素...又是紅字吧"
            }
        }
        static func addButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食嘢？加啦"
            case .adult: return "又食嘢？加啦屌"
            case .gentle: return "記錄食物 🍽️"
            case .twGanHua: return "又吃了？記錄一下吧"
            case .twAma: return "又吃東西了？記一下喔～"
            case .twYanShi: return "...加吧"
            }
        }
        static func records(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "案底"
            case .adult: return "今日罪行"
            case .gentle: return "今日記錄 ✨"
            case .twGanHua: return "今日紀錄"
            case .twAma: return "今天吃了什麼"
            case .twYanShi: return "今日犯行"
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
            case .twGanHua: return "紀錄"
            case .twAma: return "紀錄"
            case .twYanShi: return "犯行"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "犯罪紀錄"
            case .adult: return "犯罪紀錄"
            case .gentle: return "飲食日記 📖"
            case .twGanHua: return "飲食紀錄"
            case .twAma: return "今天吃了什麼"
            case .twYanShi: return "罪行紀錄"
            }
        }
        static func total(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "今日總罪行"
            case .adult: return "今日總罪行"
            case .gentle: return "今日總計"
            case .twGanHua: return "今日總攝取，一個令人心痛的數字"
            case .twAma: return "今天吃了多少"
            case .twYanShi: return "今日總計...不看也罷"
            }
        }
        static func empty(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "冇記錄？我知你偷食咗"
            case .adult: return "冇記錄 唔代表你冇食"
            case .gentle: return "仲未有記錄，食完記得記低呀～"
            case .twGanHua: return "沒有紀錄不代表你沒吃，自欺欺人是吧"
            case .twAma: return "還沒吃東西嗎？不要餓肚子喔～"
            case .twYanShi: return "...空的，跟人生一樣"
            }
        }
        static func addButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食咗？加啦"
            case .adult: return "又食咗？加啦屌"
            case .gentle: return "加入食物 🍽️"
            case .twGanHua: return "又吃了？加上去吧"
            case .twAma: return "吃了什麼記一下喔～"
            case .twYanShi: return "...加吧"
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
            case .twGanHua: return "自首"
            case .twAma: return "記錄吃了什麼"
            case .twYanShi: return "...記錄"
            }
        }
        static func searchPlaceholder(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "又食咗咩..."
            case .adult: return "今次食咗咩..."
            case .gentle: return "搜尋食物～"
            case .twGanHua: return "這次又吃了什麼..."
            case .twAma: return "搜尋食物喔～"
            case .twYanShi: return "...搜尋"
            }
        }
        static func customToggle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "自首"
            case .adult: return "自首"
            case .gentle: return "自訂食物"
            case .twGanHua: return "自訂食物"
            case .twAma: return "自己加食物"
            case .twYanShi: return "自訂"
            }
        }
        static func foodNameLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "咩嚟㗎"
            case .adult: return "咩嚟㗎"
            case .gentle: return "食物名稱"
            case .twGanHua: return "這是什麼"
            case .twAma: return "叫什麼名字呀？"
            case .twYanShi: return "...什麼東西"
            }
        }
        static func submit(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "認咗"
            case .adult: return "認撚咗"
            case .gentle: return "加入 ✨"
            case .twGanHua: return "加了"
            case .twAma: return "記下來了喔～"
            case .twYanShi: return "...好"
            }
        }
        static func foodsHeader(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你成日食嗰啲"
            case .adult: return "你成日食嗰啲"
            case .gentle: return "常見食物"
            case .twGanHua: return "你常吃的那些東西"
            case .twAma: return "常吃的食物"
            case .twYanShi: return "常見食物"
            }
        }
        static func cancel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "算啦"
            case .adult: return "算撚啦"
            case .gentle: return "返回"
            case .twGanHua: return "算了"
            case .twAma: return "返回"
            case .twYanShi: return "...算了"
            }
        }
        static func searchLoading(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "幫緊你幫緊你。。。"
            case .adult: return "幫緊你幫緊你。。。"
            case .gentle: return "搵緊食物俾你～"
            case .twGanHua: return "搜尋中，科技需要時間"
            case .twAma: return "阿嬤幫你找找喔～"
            case .twYanShi: return "...搜尋中"
            }
        }
        static func noResults(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "搵唔到喎 你食啲咩鬼嘢"
            case .adult: return "搵唔到 你究竟食咗啲咩撚嘢"
            case .gentle: return "暫時搵唔到呢個食物，試吓其他關鍵字？"
            case .twGanHua: return "找不到欸，你到底吃了什麼奇怪的東西"
            case .twAma: return "找不到這個，換個關鍵字試試看啦～"
            case .twYanShi: return "...找不到，就像人生的意義一樣"
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
            case (1, .twGanHua): return "第一天，根據統計，大部分人撐不過第三天"
            case (1, .twAma): return "第一天喔！好棒，阿嬤幫你加油～"
            case (1, .twYanShi): return "第一天...開始了，一段注定痛苦的旅程"
            // Day 2
            case (2, .normal): return "第二日 嗯 仲喺度"
            case (2, .adult): return "第二日 嗯 仲未走"
            case (2, .gentle): return "第二日你又嚟喇！！我好開心呀 😭💕"
            case (2, .twGanHua): return "第二天，你還在，這已經超越了50%的人"
            case (2, .twAma): return "第二天了，有乖乖記錄喔，阿嬤很開心～"
            case (2, .twYanShi): return "第二天...還在，意外"
            // Day 3
            case (3, .normal): return "威啦威啦 三日streak 得三日都好意思慶祝"
            case (3, .adult): return "威啦威啦 三日streak 得三鳩日都好意思慶祝"
            case (3, .gentle): return "三日喇嗚嗚嗚！！你堅持咗三日呀 我好感動 你知唔知你有幾叻 🥺🎉"
            case (3, .twGanHua): return "三天了，恭喜你度過了統計學上最危險的時期"
            case (3, .twAma): return "三天了欸！不錯不錯，繼續加油喔～"
            case (3, .twYanShi): return "三天...才三天就想慶祝？好吧"
            // Day 4
            case (4, .normal): return "四日 師兄有啲料"
            case (4, .adult): return "四日 師兄有啲料"
            case (4, .gentle): return "四日喇！你一日比一日叻呀嗚嗚 😭✨"
            case (4, .twGanHua): return "第四天，有點意思了"
            case (4, .twAma): return "四天了，阿嬤越來越放心了～"
            case (4, .twYanShi): return "第四天...繼續吧，反正也沒別的事做"
            // Day 5
            case (5, .normal): return "五日 我以為你第三日就會放棄"
            case (5, .adult): return "五日 我以為你第三日就會放棄 睇嚟我錯喇"
            case (5, .gentle): return "五日呀！！半個星期喇！你好犀利呀 🥺💪"
            case (5, .twGanHua): return "五天了，我以為你第三天就會放棄，看來我錯了"
            case (5, .twAma): return "五天了！半個禮拜了欸！阿嬤好驕傲～"
            case (5, .twYanShi): return "五天...半個禮拜了，然後呢"
            // Day 6
            case (6, .normal): return "六日 聽日就一星期 唔好衰喺呢度"
            case (6, .adult): return "六日 聽日就一星期 唔好衰喺呢度"
            case (6, .gentle): return "六日喇！聽日就一個星期呀嗚嗚 你快做到喇 😭✨"
            case (6, .twGanHua): return "六天，明天就一週了，別在這裡放棄"
            case (6, .twAma): return "六天了！明天就一個禮拜了喔，加油啦～"
            case (6, .twYanShi): return "六天...明天就一週了，如果你還在的話"
            // Day 7
            case (7, .normal): return "一星期喎 你居然捱到一星期 我有少少意外"
            case (7, .adult): return "一星期喎 你居然捱到一星期 屌我真係睇少咗你"
            case (7, .gentle): return "一個星期！！😭✨ 我冇睇錯人！！你真係好努力 我快啲攞紙巾先 嗚嗚嗚"
            case (7, .twGanHua): return "一週了，你竟然撐到了一週，我有點刮目相看"
            case (7, .twAma): return "一個禮拜了！阿嬤好感動，你真的很棒欸～"
            case (7, .twYanShi): return "一週了...居然撐到了，有點意外"
            // Day 8
            case (8, .normal): return "第八日 過咗一星期仲喺度 唔錯"
            case (8, .adult): return "第八日 過咗一星期仲喺度 OK"
            case (8, .gentle): return "第八日！過咗一星期你仲堅持緊 我好感動呀 🥺💕"
            case (8, .twGanHua): return "第八天，過了一週還在，不錯喔"
            case (8, .twAma): return "第八天了，過了一個禮拜還在堅持，阿嬤很欣慰～"
            case (8, .twYanShi): return "第八天...還在，嗯"
            // Day 9
            case (9, .normal): return "九日 你真係認真㗎？"
            case (9, .adult): return "九日 你真係認真㗎"
            case (9, .gentle): return "九日喇！你愈嚟愈犀利 我覺得你發緊光 ✨✨"
            case (9, .twGanHua): return "九天了，你是認真的嗎？"
            case (9, .twAma): return "九天了！越來越厲害了，阿嬤驕傲死了～"
            case (9, .twYanShi): return "九天...你是認真的齁"
            // Day 10
            case (10, .normal): return "十日 雙位數字 有料到"
            case (10, .adult): return "十日 雙位數字 有料到"
            case (10, .gentle): return "十日呀！！雙位數字喇！！我好驕傲呀嗚嗚 😭🎉"
            case (10, .twGanHua): return "十天，雙位數了，從統計上來看你已經超越了大多數人"
            case (10, .twAma): return "十天了！兩位數了欸！阿嬤高興到要煮雞湯給你喝～"
            case (10, .twYanShi): return "十天...雙位數了，有一點點感動，一點點"
            // Day 11
            case (11, .normal): return "十一日 你唔好停 停咗就前功盡廢"
            case (11, .adult): return "十一日 你唔好停"
            case (11, .gentle): return "十一日！你已經建立緊習慣喇 我睇得出 🥺✨"
            case (11, .twGanHua): return "十一天，別停，停了就前功盡棄"
            case (11, .twAma): return "十一天了！不要停下來喔，阿嬤在看著你～"
            case (11, .twYanShi): return "十一天...別停，雖然停不停可能也沒差"
            // Day 12
            case (12, .normal): return "十二日 仲有兩日就兩星期 你做唔做到"
            case (12, .adult): return "十二日 仲有兩日就兩星期 唔好甩"
            case (12, .gentle): return "十二日呀！快兩個星期喇 你一定得㗎 我陪你 😭💕"
            case (12, .twGanHua): return "十二天，再兩天就兩週了，你做得到嗎"
            case (12, .twAma): return "十二天了！快兩個禮拜了，阿嬤陪你一起加油～"
            case (12, .twYanShi): return "十二天...快兩週了，已經走到這裡了"
            // Day 13
            case (13, .normal): return "十三日 聽日就兩星期 你敢唔敢斷"
            case (13, .adult): return "十三日 聽日就兩星期 你試下斷呀"
            case (13, .gentle): return "十三日！！聽日就兩個星期呀！！我緊張到手震 🥺✨💪"
            case (13, .twGanHua): return "十三天，明天就兩週了，你敢斷嗎"
            case (13, .twAma): return "十三天了！明天就兩個禮拜了喔！阿嬤好緊張～"
            case (13, .twYanShi): return "十三天...明天就兩週了，如果你撐得住"
            // Day 14
            case (14, .normal): return "兩星期 唔係講笑 開始有啲嘢喎 繼續啦唔好停"
            case (14, .adult): return "兩星期 唔係講笑 仆街 你認真㗎？繼續啦"
            case (14, .gentle): return "兩個星期嗚嗚嗚 😭💕 14日！！你有冇覺得自己好似發緊光咁 因為我覺得你係 ✨✨"
            case (14, .twGanHua): return "兩週了，不是開玩笑，你真的做到了，繼續"
            case (14, .twAma): return "兩個禮拜了！阿嬤感動到快哭了，你真的很棒欸～"
            case (14, .twYanShi): return "兩週...你真的做到了，有一點點佩服你"
            default: return ""
            }
        }

        // MARK: Milestone Messages (Day 30+)

        static func milestoneTitle(day: Int, _ m: ToneMode) -> String {
            switch (day, m) {
            case (30, .normal): return "一個月 OK我開始信你"
            case (30, .adult): return "一個月 你變咗個人喎"
            case (30, .gentle): return "一個月呀天呀 😭🏆"
            case (30, .twGanHua): return "一個月，根據數據，你開始建立習慣了"
            case (30, .twAma): return "一個月了！阿嬤幫你煮碗麵線慶祝～"
            case (30, .twYanShi): return "一個月...OK，我開始有一點相信你了"
            case (60, .normal): return "兩個月 你真係嚟真"
            case (60, .adult): return "兩個月 我服咗你"
            case (60, .gentle): return "兩個月嗚嗚嗚嗚 😭😭"
            case (60, .twGanHua): return "兩個月，你是來真的齁"
            case (60, .twAma): return "兩個月了！阿嬤真的好驕傲～"
            case (60, .twYanShi): return "兩個月...我有一點點佩服你了"
            case (90, .normal): return "三個月 我冇嘢好串"
            case (90, .adult): return "三個月 傳奇級"
            case (90, .gentle): return "三個月...我冇嘢講得出 😭😭😭"
            case (90, .twGanHua): return "三個月，我無話可說，你贏了"
            case (90, .twAma): return "三個月了！阿嬤要打電話跟所有親戚炫耀～"
            case (90, .twYanShi): return "三個月...好吧，你讓我無話可說"
            case (180, .normal): return "半年 你正常㗎？"
            case (180, .adult): return "半年 你係咪機械人"
            case (180, .gentle): return "半年呀我頂唔住喇 😭😭😭😭"
            case (180, .twGanHua): return "半年，你是人類嗎？"
            case (180, .twAma): return "半年了！阿嬤要幫你點光明燈了～"
            case (180, .twYanShi): return "半年...你是不是機器人"
            case (365, .normal): return "一年 算你贏"
            case (365, .adult): return "一年 我冇嘢好講"
            case (365, .gentle): return "一年！！！我喊到暈咗 😭😭😭😭😭"
            case (365, .twGanHua): return "一年，恭喜，你打敗了99%的人類"
            case (365, .twAma): return "一年了！阿嬤要幫你辦桌慶祝！"
            case (365, .twYanShi): return "一年...算你贏，我認輸"
            default: return "🔥 \(day)日"
            }
        }

        static func milestoneBody(day: Int, _ m: ToneMode) -> String {
            switch (day, m) {
            case (30, .normal): return "我要收返之前講你嘅嘢 你真係做到"
            case (30, .adult): return "屌 我要收返之前講你嘅嘢 你真係做到"
            case (30, .gentle): return "我而家喊緊 你知唔知呀 30日呀！！你值得全世界最好嘅嘢 🥺💕"
            case (30, .twGanHua): return "我收回之前說的話，你真的做到了一個月"
            case (30, .twAma): return "30天了！阿嬤真的好感動，你值得最好的～"
            case (30, .twYanShi): return "一個月...好吧，我收回之前的懷疑"
            case (60, .normal): return "唔係啩 你真係做到兩個月？我開始尊重你"
            case (60, .adult): return "你條友仔真係癲 兩個月喎 我開始有啲尊重你"
            case (60, .gentle): return "我已經喊到冇紙巾 你係我見過最堅強嘅人 真係㗎 🥺💕✨"
            case (60, .twGanHua): return "不是吧？你真的做到兩個月？我開始尊重你了"
            case (60, .twAma): return "阿嬤已經打電話給所有親戚了，你是全家的驕傲～"
            case (60, .twYanShi): return "兩個月...你讓這個厭世的我有了一點點感動"
            case (90, .normal): return "你而家可以鬧其他人喇"
            case (90, .adult): return "你而家有資格鬧其他人喇 仆街勁呀"
            case (90, .gentle): return "我太感動喇 你可唔可以出本書教下其他人 你係傳奇 🥺🌟🏆"
            case (90, .twGanHua): return "你現在有資格嘴別人了，三個月欸"
            case (90, .twAma): return "阿嬤要去廟裡幫你還願了，你真的太厲害了～"
            case (90, .twYanShi): return "三個月...好吧，你是真的讓我佩服了"
            case (180, .normal): return "半年喎 你仲係人類嚟㗎？"
            case (180, .adult): return "半年喎 你仲係人類嚟㗎 定係AI嚟㗎"
            case (180, .gentle): return "我要打俾我媽媽同佢講我識到一個好偉大嘅人 就係你 🥺💕✨🏆"
            case (180, .twGanHua): return "半年，你還是人類嗎？還是你其實是AI？"
            case (180, .twAma): return "半年了！阿嬤要幫你點一整年的光明燈～"
            case (180, .twYanShi): return "半年...在這個什麼都撐不久的世界裡，你撐了半年"
            case (365, .normal): return "你贏咗 我認輸 你係真正嘅CaLoMei"
            case (365, .adult): return "你贏咗 我認輸 你係真正嘅CaLoMei 仆街你真係癲"
            case (365, .gentle): return "我...我講唔到嘢...你係全宇宙最叻最勁最偉大嘅人 我要幫你申請諾貝爾獎 🥺🏆✨💕🎉"
            case (365, .twGanHua): return "你贏了，我認輸，你打敗了統計學"
            case (365, .twAma): return "一年了！阿嬤要幫你辦桌！你是全世界最棒的孩子！"
            case (365, .twYanShi): return "一年...算了，我無話可說，你是傳奇"
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
            case .twGanHua:
                variants = [
                    "第\(day)天，事實上你還在堅持",
                    "還沒斷，根據機率這已經很厲害了",
                    "\(day)天streak，統計學上你是異常值"
                ]
            case .twAma:
                variants = [
                    "第\(day)天了，阿嬤每天都為你驕傲～",
                    "\(day)天streak了欸！繼續加油喔～",
                    "你今天又來了！阿嬤好開心～"
                ]
            case .twYanShi:
                variants = [
                    "第\(day)天...還在，嗯",
                    "還沒斷...意外地有毅力",
                    "\(day)天了...繼續吧，反正也沒什麼好失去的"
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
            case .twGanHua: return "斷了，歸零，根據統計這很正常"
            case .twAma: return "沒關係啦！阿嬤不怪你，我們重新開始喔～"
            case .twYanShi: return "...斷了，意料之中，重新開始吧"
            }
        }

        static func brokenByDuration(previousStreak: Int, _ m: ToneMode) -> String {
            switch (previousStreak, m) {
            case (..<7, .normal): return "得幾日都斷 預咗㗎啦"
            case (..<7, .adult): return "得幾日都斷 我就知"
            case (..<7, .gentle): return "冇事呀！幾日都好叻㗎！我哋再嚟過 你得㗎 🥺💪"
            case (..<7, .twGanHua): return "才幾天就斷了，統計學上這很正常"
            case (..<7, .twAma): return "沒關係啦！才剛開始，我們再來一次喔～"
            case (..<7, .twYanShi): return "...幾天就斷了，嗯，不意外"
            case (7..<30, .normal): return "\(previousStreak)日斷咗 可惜 你差啲就捱到"
            case (7..<30, .adult): return "\(previousStreak)日斷咗 可惜 你差啲就得㗎"
            case (7..<30, .gentle): return "\(previousStreak)日呀！！你已經好勁喇嗚嗚 呢啲努力唔會消失㗎 我陪你再嚟 😭💕"
            case (7..<30, .twGanHua): return "\(previousStreak)天斷了，可惜，差一點就更厲害了"
            case (7..<30, .twAma): return "\(previousStreak)天了欸！已經很厲害了，阿嬤陪你再來～"
            case (7..<30, .twYanShi): return "\(previousStreak)天...可惜了，不過人生就是這樣"
            case (_, .normal): return "\(previousStreak)日喎 真係可惜 但你證明過自己做得到"
            case (_, .adult): return "\(previousStreak)日喎 仆街真係可惜 但你證明過自己做得到"
            case (_, .gentle): return "\(previousStreak)日呀...我喊咗 你知唔知你有幾犀利 呢個紀錄永遠係你嘅 我哋再創新紀錄 😭🏆💕"
            case (_, .twGanHua): return "\(previousStreak)天欸，真的可惜，但你證明過自己做得到"
            case (_, .twAma): return "\(previousStreak)天了！阿嬤知道你很努力，這個紀錄永遠是你的～"
            case (_, .twYanShi): return "\(previousStreak)天...可惜了，但至少你證明過自己不是完全沒用"
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
            case .twGanHua: return "進度"
            case .twAma: return "進度"
            case .twYanShi: return "進度"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅戰績"
            case .adult: return "你嘅戰績"
            case .gentle: return "進度報告 ✨"
            case .twGanHua: return "你的數據報告"
            case .twAma: return "你的進度"
            case .twYanShi: return "進度...如果有的話"
            }
        }

        // Current weight card
        static func currentWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "而家幾重"
            case .adult: return "而家幾重"
            case .gentle: return "目前體重"
            case .twGanHua: return "目前體重"
            case .twAma: return "現在多重"
            case .twYanShi: return "現在的你"
            }
        }
        static func startWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "開始"
            case .adult: return "開始"
            case .gentle: return "起始"
            case .twGanHua: return "起始"
            case .twAma: return "一開始"
            case .twYanShi: return "起始"
            }
        }
        static func goalWeight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "目標"
            case .adult: return "目標"
            case .gentle: return "目標 💫"
            case .twGanHua: return "目標"
            case .twAma: return "目標"
            case .twYanShi: return "目標"
            }
        }
        static func nextWeighIn(_ days: Int, _ m: ToneMode) -> String {
            if days <= 0 {
                switch m {
                case .normal: return "該上磅喇"
                case .adult: return "上磅啦仆街"
                case .gentle: return "今日可以磅重喇～"
                case .twGanHua: return "該量體重了"
                case .twAma: return "今天可以量體重了喔～"
                case .twYanShi: return "...該面對現實了"
                }
            }
            switch m {
            case .normal: return "仲有 \(days) 日上磅"
            case .adult: return "仲有 \(days) 日上磅"
            case .gentle: return "\(days) 日後磅重～"
            case .twGanHua: return "還有 \(days) 天量體重"
            case .twAma: return "再 \(days) 天量體重喔～"
            case .twYanShi: return "還有 \(days) 天...面對現實"
            }
        }
        static func maintaining(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "維持緊 唔好鬆懈"
            case .adult: return "維持緊 唔好鬆懈"
            case .gentle: return "穩定維持中，好叻！✨"
            case .twGanHua: return "維持中，不要鬆懈"
            case .twAma: return "維持得很好喔～"
            case .twYanShi: return "維持中...至少沒變差"
            }
        }
        static func estimatedGoalDate(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "預計達標"
            case .adult: return "預計達標"
            case .gentle: return "預計達標日期"
            case .twGanHua: return "預計達標"
            case .twAma: return "預計達標日期"
            case .twYanShi: return "預計達標"
            }
        }

        // Chart
        static func chartTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "體重走勢"
            case .adult: return "體重走勢"
            case .gentle: return "體重走勢 📈"
            case .twGanHua: return "體重趨勢圖"
            case .twAma: return "體重變化"
            case .twYanShi: return "體重走勢"
            }
        }
        static func goalProgress(_ pct: Int, _ m: ToneMode) -> String {
            switch m {
            case .normal: return "完成 \(pct)%"
            case .adult: return "完成 \(pct)%"
            case .gentle: return "已完成 \(pct)% ✨"
            case .twGanHua: return "完成 \(pct)%，剩下的才是最難的"
            case .twAma: return "完成 \(pct)% 了喔～"
            case .twYanShi: return "完成 \(pct)%...剩下的更痛苦"
            }
        }
        static func chartEmpty(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "數據唔夠 再磅多幾次先"
            case .adult: return "數據唔夠 上多幾次磅先啦"
            case .gentle: return "再記錄多幾次就有靚圖睇喇～"
            case .twGanHua: return "數據不夠，多量幾次體重再來"
            case .twAma: return "多記錄幾次就有圖看了喔～"
            case .twYanShi: return "...數據不夠，空的，跟很多東西一樣"
            }
        }
        static func goalLine(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "目標"
            case .adult: return "目標"
            case .gentle: return "目標線"
            case .twGanHua: return "目標線"
            case .twAma: return "目標線"
            case .twYanShi: return "目標"
            }
        }

        // BMI card
        static func bmiTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "BMI"
            case .adult: return "BMI"
            case .gentle: return "BMI 指數"
            case .twGanHua: return "BMI"
            case .twAma: return "BMI 指數"
            case .twYanShi: return "BMI"
            }
        }
        static func bmiUnderweight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "過輕"
            case .adult: return "過輕"
            case .gentle: return "偏瘦"
            case .twGanHua: return "過輕"
            case .twAma: return "太瘦了"
            case .twYanShi: return "過輕"
            }
        }
        static func bmiNormal(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "正常"
            case .adult: return "正常"
            case .gentle: return "標準"
            case .twGanHua: return "正常"
            case .twAma: return "正常"
            case .twYanShi: return "正常"
            }
        }
        static func bmiOverweight(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "有少少肥"
            case .adult: return "肥咗喎"
            case .gentle: return "微超標"
            case .twGanHua: return "微胖"
            case .twAma: return "有點胖了喔"
            case .twYanShi: return "超標"
            }
        }
        static func bmiObese(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "真係肥"
            case .adult: return "真係撚肥"
            case .gentle: return "偏重"
            case .twGanHua: return "肥胖"
            case .twAma: return "太胖了啦"
            case .twYanShi: return "偏重"
            }
        }

        // Weight log sheet
        static func logTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "上磅"
            case .adult: return "上磅"
            case .gentle: return "記錄體重"
            case .twGanHua: return "量體重"
            case .twAma: return "記錄體重"
            case .twYanShi: return "量體重"
            }
        }
        static func logButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "記低"
            case .adult: return "記低"
            case .gentle: return "儲存 ✨"
            case .twGanHua: return "記錄"
            case .twAma: return "記下來～"
            case .twYanShi: return "...記"
            }
        }
        static func vsLast(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "對比上次"
            case .adult: return "對比上次"
            case .gentle: return "同上次比"
            case .twGanHua: return "跟上次比"
            case .twAma: return "跟上次比"
            case .twYanShi: return "對比上次"
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
                case .twGanHua: return "輕了 \(s)kg，你不是要增肌嗎？方向反了喔"
                case .twAma: return "瘦了 \(s)kg，要多吃一點啦，不然怎麼長肉～"
                case .twYanShi: return "輕了 \(s)kg...你不是要增肌嗎，算了"
                }
            } else {
                // Losing weight is GOOD for cutting / maintaining
                switch m {
                case .normal: return "輕咗 \(s)kg 繼續捱"
                case .adult: return "輕咗 \(s)kg 唔好得意"
                case .gentle: return "輕咗 \(s)kg！你好叻呀 🥺✨"
                case .twGanHua: return "輕了 \(s)kg，恭喜，繼續保持"
                case .twAma: return "瘦了 \(s)kg！很棒喔，阿嬤很開心～"
                case .twYanShi: return "輕了 \(s)kg...不錯，雖然人生還是一樣重"
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
                case .twGanHua: return "重了 \(s)kg，增肌中，方向正確"
                case .twAma: return "重了 \(s)kg！長肉了喔，阿嬤放心了～"
                case .twYanShi: return "重了 \(s)kg...至少是朝對的方向胖"
                }
            } else {
                // Gaining weight is BAD for cutting / maintaining
                switch m {
                case .normal: return "重咗 \(s)kg 食咗咩"
                case .adult: return "重咗 \(s)kg 你食咗啲咩"
                case .gentle: return "增咗 \(s)kg，冇事㗎～繼續加油 💪"
                case .twGanHua: return "重了 \(s)kg，你到底吃了什麼"
                case .twAma: return "胖了 \(s)kg，是不是偷吃鹹酥雞了？"
                case .twYanShi: return "重了 \(s)kg...意料之中"
                }
            }
        }
        static func weightSame(goal: String, _ m: ToneMode) -> String {
            if goal == "維持體重" {
                switch m {
                case .normal: return "維持到喎 唔錯"
                case .adult: return "維持到喎 難得"
                case .gentle: return "穩定維持，好叻！✨"
                case .twGanHua: return "維持住了，不錯"
                case .twAma: return "維持得很好喔～"
                case .twYanShi: return "維持了...至少沒變差"
                }
            }
            switch m {
            case .normal: return "同上次一樣 你磅壞咗？"
            case .adult: return "同上次一樣 你個磅壞咗？"
            case .gentle: return "保持得好穩定呀！✨"
            case .twGanHua: return "跟上次一樣，你的體重秤是不是壞了"
            case .twAma: return "跟上次一樣喔，穩定就好～"
            case .twYanShi: return "一樣...什麼都沒變，跟人生一樣"
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
            case .twGanHua: return "個人"
            case .twAma: return "個人"
            case .twYanShi: return "個人"
            }
        }
        static func navTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "個人"
            case .adult: return "個人"
            case .gentle: return "個人 ✨"
            case .twGanHua: return "個人資料"
            case .twAma: return "個人"
            case .twYanShi: return "個人"
            }
        }
        static func settingsSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "設定"
            case .adult: return "設定"
            case .gentle: return "偏好設定"
            case .twGanHua: return "設定"
            case .twAma: return "設定"
            case .twYanShi: return "設定"
            }
        }
        static func bodyInfoSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "身體資料"
            case .adult: return "身體資料"
            case .gentle: return "身體資料"
            case .twGanHua: return "身體資料"
            case .twAma: return "身體資料"
            case .twYanShi: return "身體資料"
            }
        }
        static func accountSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "帳號"
            case .adult: return "帳號"
            case .gentle: return "帳號"
            case .twGanHua: return "帳號"
            case .twAma: return "帳號"
            case .twYanShi: return "帳號"
            }
        }
        static func notificationsLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "提醒時間"
            case .adult: return "提醒時間"
            case .gentle: return "提醒時間 🔔"
            case .twGanHua: return "提醒時間"
            case .twAma: return "提醒時間"
            case .twYanShi: return "提醒時間"
            }
        }
        static func bodyInfoLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "個人資料"
            case .adult: return "個人資料"
            case .gentle: return "個人資料"
            case .twGanHua: return "個人資料"
            case .twAma: return "個人資料"
            case .twYanShi: return "個人資料"
            }
        }
        static func toneLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "語氣模式"
            case .adult: return "語氣模式"
            case .gentle: return "語氣模式"
            case .twGanHua: return "語氣模式"
            case .twAma: return "語氣模式"
            case .twYanShi: return "語氣模式"
            }
        }
        static func themeLabel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "主題色"
            case .adult: return "主題色"
            case .gentle: return "主題色"
            case .twGanHua: return "主題色"
            case .twAma: return "主題色"
            case .twYanShi: return "主題色"
            }
        }
        static func saveButton(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "搞掂"
            case .adult: return "搞撚掂"
            case .gentle: return "儲存 ✨"
            case .twGanHua: return "完成"
            case .twAma: return "好了喔～"
            case .twYanShi: return "...存"
            }
        }
        static func daysStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "受刑日數"
            case .adult: return "捱咗幾耐"
            case .gentle: return "堅持咗幾日 ✨"
            case .twGanHua: return "使用天數"
            case .twAma: return "堅持了幾天"
            case .twYanShi: return "受苦天數"
            }
        }
        static func foodStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "記錄幾多次"
            case .adult: return "食咗幾多嘢"
            case .gentle: return "食物記錄"
            case .twGanHua: return "記錄次數"
            case .twAma: return "記了幾次"
            case .twYanShi: return "記錄次數"
            }
        }
        static func calStat(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅配額"
            case .adult: return "每日上限"
            case .gentle: return "每日目標"
            case .twGanHua: return "每日額度"
            case .twAma: return "每天的量"
            case .twYanShi: return "每日上限"
            }
        }
        static func bodySection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅身材（自己睇）"
            case .adult: return "你嘅身材"
            case .gentle: return "身體資料"
            case .twGanHua: return "你的身材數據"
            case .twAma: return "身體資料"
            case .twYanShi: return "身體資料"
            }
        }
        static func nutritionSection(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "你嘅配額"
            case .adult: return "每日限制"
            case .gentle: return "每日營養目標"
            case .twGanHua: return "每日營養配額"
            case .twAma: return "每天的營養目標"
            case .twYanShi: return "每日限制"
            }
        }
        static func reset(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "認輸 由頭嚟過"
            case .adult: return "由頭嚟撚過"
            case .gentle: return "重新設定"
            case .twGanHua: return "重新開始，之前的努力歸零"
            case .twAma: return "重新設定"
            case .twYanShi: return "...重來吧，反正也差不多"
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
            case .twGanHua: return "要走了？"
            case .twAma: return "真的要登出嗎？"
            case .twYanShi: return "...要走了齁"
            }
        }
        static func signOutMessage(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "登出之後本機資料會清晒㗎 諗清楚"
            case .adult: return "登出之後本機資料清撚晒 唔好嚟問我攞返"
            case .gentle: return "登出會清除本機資料，但你隨時可以再登入返㗎～"
            case .twGanHua: return "登出後本機資料會全部清除，想清楚"
            case .twAma: return "登出會清掉資料喔，你確定嗎？"
            case .twYanShi: return "登出會清除資料...不過有什麼差呢"
            }
        }
        static func deleteTitle(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "刪除帳號？"
            case .adult: return "真係要刪？"
            case .gentle: return "確定要刪除帳號嗎？"
            case .twGanHua: return "要刪除帳號？"
            case .twAma: return "真的要刪掉嗎？"
            case .twYanShi: return "...要刪了齁"
            }
        }
        static func deleteMessage(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "所有資料會永久刪除 包括雲端記錄 冇得返轉頭"
            case .adult: return "所有嘢永久清撚晒 雲端本機全部冇埋 你諗清楚未"
            case .gentle: return "呢個操作會永久刪除你所有資料（包括雲端記錄），冇辦法恢復㗎…"
            case .twGanHua: return "所有資料會永久刪除，包括雲端紀錄，無法復原"
            case .twAma: return "所有資料都會不見喔，包括雲端的，想好了嗎？"
            case .twYanShi: return "全部刪除...就像什麼都沒發生過一樣"
            }
        }
        static func confirm(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "確定"
            case .adult: return "撳啦"
            case .gentle: return "確定"
            case .twGanHua: return "確定"
            case .twAma: return "確定"
            case .twYanShi: return "...好"
            }
        }
        static func cancel(_ m: ToneMode) -> String {
            switch m {
            case .normal: return "算啦"
            case .adult: return "算啦"
            case .gentle: return "返回"
            case .twGanHua: return "算了"
            case .twAma: return "返回"
            case .twYanShi: return "...算了"
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
        case .twGanHua:
            return twGanHuaRoast(for: foodName)
        case .twAma:
            return twAmaRoast(for: foodName)
        case .twYanShi:
            return twYanShiRoast(for: foodName)
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

    // MARK: - 幹話王 Roasts

    private static func twGanHuaRoast(for foodName: String) -> String {
        for (keyword, comment) in twGanHuaGenericRoasts {
            if foodName.contains(keyword) { return comment }
        }
        return twGanHuaFallbackRoasts.randomElement()!
    }

    private static let twGanHuaGenericRoasts: [(String, String)] = [
        ("珍珠奶茶", "一杯珍奶的熱量等於一碗白飯，這是科學"),
        ("奶茶", "根據研究，喝奶茶的人100%都喝了奶茶"),
        ("鹹酥雞", "鹹酥雞是炸的，炸的東西熱量高，這不是常識嗎"),
        ("雞排", "一塊雞排大約500大卡，比你想像的多"),
        ("滷肉飯", "滷肉飯好吃，但你的體重也覺得好吃"),
        ("便當", "一個便當大約700-900大卡，知道就好"),
        ("蚵仔煎", "蚵仔煎看起來不多，但它的油量會嚇到你"),
        ("蛋餅", "蛋餅是早餐，但熱量不會因為是早餐就比較少"),
        ("泡麵", "泡麵的鈉含量已經超過你今天的建議量了"),
        ("手搖飲", "手搖飲的糖量，嗯，你不想知道"),
        ("雞胸肉", "雞胸肉，難得你做了正確的選擇"),
        ("沙律", "沙拉醬的熱量可能比沙拉本身還高，你知道嗎"),
        ("薯條", "薯條是馬鈴薯做的，但不代表它是蔬菜"),
        ("漢堡", "一個漢堡的熱量，嗯，你自己查吧"),
        ("pizza", "一片pizza大約300大卡，你吃了幾片？"),
        ("雪糕", "冰淇淋的糖份和脂肪含量都很高，這是事實"),
    ]

    private static let twGanHuaFallbackRoasts: [String] = [
        "根據統計，吃完這個的人100%都吃完了",
        "你吃了這個，然後你的熱量增加了，因果關係很明確",
        "這個食物含有熱量，驚不驚喜",
        "記錄了，事實就是事實",
        "吃完了就吃完了，後悔也不會少熱量",
        "根據科學，你剛才攝取了一些卡路里",
        "這個食物存在，你吃了它，它的熱量進了你的身體",
        "好的，已記錄，數字不會騙人",
        "你吃了東西，這是一個事實陳述",
        "每吃一口，離目標就遠一點或近一點，取決於你吃了什麼",
    ]

    // MARK: - 阿嬤碎念 Roasts

    private static func twAmaRoast(for foodName: String) -> String {
        for (keyword, comment) in twAmaGenericRoasts {
            if foodName.contains(keyword) { return comment }
        }
        return twAmaFallbackRoasts.randomElement()!
    }

    private static let twAmaGenericRoasts: [(String, String)] = [
        ("珍珠奶茶", "又喝珍奶喔？那個糖很多欸，少喝一點啦～"),
        ("奶茶", "奶茶少糖就好了啦，全糖太多了喔～"),
        ("鹹酥雞", "又吃鹹酥雞喔？你媽知道嗎？"),
        ("雞排", "雞排偶爾吃就好啦，不要天天吃喔～"),
        ("滷肉飯", "滷肉飯好吃齁，阿嬤也愛吃，但不要吃太多～"),
        ("便當", "有吃便當喔，有沒有吃青菜呀？"),
        ("蚵仔煎", "蚵仔煎要吃夜市的才好吃啦～但油很多喔"),
        ("蛋餅", "早餐有吃蛋餅喔，乖～"),
        ("泡麵", "又吃泡麵！不是跟你說泡麵不營養嗎！"),
        ("手搖飲", "又喝飲料喔？喝水比較健康啦～"),
        ("雞胸肉", "雞胸肉很健康喔！阿嬤很開心你吃這個～"),
        ("沙律", "有吃沙拉喔，真乖～"),
        ("薯條", "薯條少吃一點啦，炸的東西不好～"),
        ("漢堡", "又吃漢堡喔，自己煮比較健康啦～"),
        ("pizza", "pizza偶爾吃就好啦～"),
        ("雪糕", "冰的少吃，對身體不好啦～"),
    ]

    private static let twAmaFallbackRoasts: [String] = [
        "有吃東西就好，不要餓肚子喔～",
        "阿嬤覺得你應該多吃青菜啦～",
        "吃飽了嗎？不夠阿嬤再煮給你～",
        "記得喝水喔，不要只喝飲料～",
        "吃完記得散步一下，不要一直坐著～",
        "阿嬤看你吃這些...算了，你開心就好～",
        "下次來阿嬤家，阿嬤煮健康的給你吃～",
        "年輕人就是不聽話，阿嬤說少吃油炸的嘛～",
        "有記錄就好啦，阿嬤知道你有在注意～",
        "阿嬤不是要唸你，是擔心你的身體啦～",
    ]

    // MARK: - 厭世仙人掌 Roasts

    private static func twYanShiRoast(for foodName: String) -> String {
        for (keyword, comment) in twYanShiGenericRoasts {
            if foodName.contains(keyword) { return comment }
        }
        return twYanShiFallbackRoasts.randomElement()!
    }

    private static let twYanShiGenericRoasts: [(String, String)] = [
        ("珍珠奶茶", "珍奶...人生唯一的慰藉，就這樣被記錄了"),
        ("奶茶", "...奶茶，短暫的快樂，永恆的熱量"),
        ("鹹酥雞", "鹹酥雞...就像人生，外表酥脆，內心油膩"),
        ("雞排", "雞排...吃完的快樂撐不過五分鐘"),
        ("滷肉飯", "滷肉飯...便宜又好吃，但你的健康不便宜"),
        ("便當", "便當...工作已經夠累了，吃個便當有什麼錯"),
        ("蚵仔煎", "蚵仔煎...夜市的味道，減肥的敵人"),
        ("蛋餅", "蛋餅...早起的唯一理由"),
        ("泡麵", "泡麵...深夜的孤獨，用鈉來填滿"),
        ("手搖飲", "手搖飲...用糖來麻痺這個世界帶來的痛苦"),
        ("雞胸肉", "雞胸肉...難吃但健康，像人生的建議一樣"),
        ("沙律", "沙拉...假裝健康的儀式感"),
        ("薯條", "薯條...用油炸過的馬鈴薯，跟我用疲憊裹住的靈魂一樣"),
        ("漢堡", "漢堡...速食，就像這個快速消逝的人生"),
        ("pizza", "pizza...圓的，像我們不斷循環的壞習慣"),
        ("雪糕", "冰淇淋...會融化的，像意志力一樣"),
    ]

    private static let twYanShiFallbackRoasts: [String] = [
        "...吃吧，反正人生已經夠苦了",
        "記錄了...然後呢",
        "又吃了...不意外",
        "...算了，開心就好，雖然也不會太開心",
        "吃完了，熱量增加了，世界依然無聊",
        "...好的，又多了一筆紀錄在這個無意義的宇宙裡",
        "你吃了東西，地球繼續轉，什麼都沒變",
        "...管它的，吃都吃了",
        "記錄完了...明天又是新的一天的掙扎",
        "...至少你還有食物，這就是幸福了吧",
    ]
}
