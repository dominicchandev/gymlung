//
//  StreakManager.swift
//  GymLung
//
//  Created by Chan Tin Lok on 27/2/2026.
//

import Foundation
import SwiftData

enum StreakEvent {
    case milestone(Int)   // days 1-14, or milestone days (30,60,90,180,365)
    case continued(Int)   // non-milestone day 15+
    case broken(Int)      // previous streak that was broken
}

@Observable
final class StreakManager {

    private static let hkt = TimeZone(identifier: "Asia/Hong_Kong")!

    private static var hktCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = hkt
        return cal
    }

    // MARK: - Core Calculation

    /// Recalculates streak from food entries and updates profile.
    static func calculateStreak(entries: [FoodEntry], profile: UserProfile) {
        let cal = hktCalendar
        let today = cal.startOfDay(for: Date())

        // Get unique calendar days (HKT) that have entries, sorted descending
        let daysWithEntries = Set(entries.map { cal.startOfDay(for: $0.date) })
            .sorted(by: >)

        guard !daysWithEntries.isEmpty else {
            profile.currentStreak = 0
            profile.lastLogDate = nil
            return
        }

        // Check if today or yesterday has entries (streak must be current)
        let yesterday = cal.date(byAdding: .day, value: -1, to: today)!
        let mostRecentDay = daysWithEntries[0]

        guard mostRecentDay >= yesterday else {
            // Last entry was before yesterday — streak is broken
            profile.currentStreak = 0
            profile.lastLogDate = mostRecentDay
            return
        }

        // Count consecutive days backwards from most recent
        var streak = 1
        var checkDate = mostRecentDay

        for i in 1..<daysWithEntries.count {
            let previousDay = cal.date(byAdding: .day, value: -1, to: checkDate)!
            if cal.isDate(daysWithEntries[i], inSameDayAs: previousDay) {
                streak += 1
                checkDate = daysWithEntries[i]
            } else {
                break
            }
        }

        profile.currentStreak = streak
        profile.longestStreak = max(profile.longestStreak, streak)
        profile.lastLogDate = mostRecentDay
    }

    // MARK: - App Launch Check

    /// Returns a broken event if streak was broken since last check.
    static func checkOnAppLaunch(entries: [FoodEntry], profile: UserProfile) -> StreakEvent? {
        let previousStreak = profile.currentStreak
        calculateStreak(entries: entries, profile: profile)

        // If there was a streak and now it's 0, it's broken
        if previousStreak > 0 && profile.currentStreak == 0 && !profile.streakBrokenShown {
            profile.streakBrokenShown = true
            return .broken(previousStreak)
        }

        // Reset broken flag if streak is active again
        if profile.currentStreak > 0 {
            profile.streakBrokenShown = false
        }

        return nil
    }

    // MARK: - After Food Log Check

    /// Returns a celebration event if this is the first log of today.
    static func checkAfterFoodLog(entries: [FoodEntry], profile: UserProfile) -> StreakEvent? {
        let cal = hktCalendar
        let today = cal.startOfDay(for: Date())

        // Count how many entries are from today
        let todayEntries = entries.filter { cal.isDate($0.date, inSameDayAs: today) }

        // Only trigger on first entry of the day
        guard todayEntries.count == 1 else {
            // Still recalculate to keep numbers fresh
            calculateStreak(entries: entries, profile: profile)
            return nil
        }

        calculateStreak(entries: entries, profile: profile)
        let day = profile.currentStreak

        // Reset broken shown flag since user is logging again
        profile.streakBrokenShown = false

        // Check if already celebrated this day
        let lastCelebrated = UserDefaults.standard.integer(forKey: "lastStreakCelebrationDay")
        if lastCelebrated == day && day > 0 {
            return nil
        }

        // Mark as celebrated
        UserDefaults.standard.set(day, forKey: "lastStreakCelebrationDay")

        let milestoneDays: Set<Int> = [30, 60, 90, 180, 365]

        if day >= 1 && day <= 14 {
            return .milestone(day)
        } else if milestoneDays.contains(day) {
            return .milestone(day)
        } else if day >= 15 {
            return .continued(day)
        }

        return nil
    }
}
