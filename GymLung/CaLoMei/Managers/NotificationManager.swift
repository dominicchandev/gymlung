//
//  NotificationManager.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import Foundation
import UserNotifications

@Observable
class NotificationManager {
    var isAuthorized = false

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run { isAuthorized = granted }
            return granted
        } catch {
            return false
        }
    }

    func scheduleMealReminders(breakfast: Date, lunch: Date, dinner: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        scheduleMeal(id: "breakfast", time: breakfast, center: center)
        scheduleMeal(id: "lunch", time: lunch, center: center)
        scheduleMeal(id: "dinner", time: dinner, center: center)
    }

    func removeAllScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Trial Reminder

    static func scheduleTrialReminder() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["trial_ending_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "CaLoMei"
        content.sound = .default

        let regionRaw = UserDefaults.standard.string(forKey: "region") ?? Region.hk.rawValue
        let region = Region(rawValue: regionRaw) ?? .hk

        switch region {
        case .hk:
            content.body = "你嘅3日免費試用聽日就完㗎喇 唔cancel就要收錢啦"
        case .tw:
            content.body = "你的3天免費試用明天就到期了 不取消就要收費囉"
        }

        // Fire 48h from now (Day 2 of 3-day trial, ~24h before billing)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 48 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: "trial_ending_reminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error {
                debugPrint("[NotificationManager] Failed to schedule trial reminder: \(error)")
            } else {
                debugPrint("[NotificationManager] Trial reminder scheduled for 48h from now")
            }
        }
    }

    private func scheduleMeal(id: String, time: Date, center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.sound = .default

        let toneModeRaw = UserDefaults.standard.string(forKey: "toneMode") ?? ToneMode.normal.rawValue
        let mode = ToneMode(rawValue: toneModeRaw) ?? .normal

        switch (id, mode) {
        case ("breakfast", .normal):
            content.title = "CaLoMei"
            content.body = "起身喇 記得食早餐同記低佢"
        case ("breakfast", .adult):
            content.title = "CaLoMei"
            content.body = "起身喇 食完早餐記得認罪"
        case ("breakfast", .gentle):
            content.title = "CaLoMei"
            content.body = "早安～記得食早餐呀 🌅"
        case ("lunch", .normal):
            content.title = "CaLoMei"
            content.body = "lunch喇 食完記得記低"
        case ("lunch", .adult):
            content.title = "CaLoMei"
            content.body = "lunch喇 食完記得認罪 屌"
        case ("lunch", .gentle):
            content.title = "CaLoMei"
            content.body = "中午喇～食飯時間到 🍽️"
        case ("dinner", .normal):
            content.title = "CaLoMei"
            content.body = "晚飯時間 又有咩罪行"
        case ("dinner", .adult):
            content.title = "CaLoMei"
            content.body = "晚飯喇 食完記得認罪"
        case ("dinner", .gentle):
            content.title = "CaLoMei"
            content.body = "晚飯時間到～記得食嘢呀 🌙"
        default:
            content.title = "CaLoMei"
            content.body = "記得記低你食咗咩"
        }

        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: time)
        dateComponents.minute = calendar.component(.minute, from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "meal_\(id)", content: content, trigger: trigger)

        center.add(request)
    }
}
