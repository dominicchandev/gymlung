//
//  ProfilePage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData
import UserNotifications

struct ProfilePage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppStateManager.self) var appStateManager
    @Environment(AuthManager.self) var authManager
    @Environment(DataSyncManager.self) var dataSyncManager
    @Query private var profiles: [UserProfile]
    @Query(sort: \FoodEntry.createdAt, order: .reverse) private var allEntries: [FoodEntry]
    @Query private var weightEntries: [WeightEntry]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @AppStorage("colorTheme") private var colorThemeRaw: String = ColorTheme.amber.rawValue
    @AppStorage("lastStreakCelebrationDay") private var lastStreakCelebrationDay: Int = 0
    @State private var showToneSettings = false
    @State private var showThemePicker = false
    @State private var showMealTimesSheet = false
    @State private var showBodyInfoSheet = false
    @State private var showSignOutAlert = false
    @State private var showDeleteAlert = false
    @State private var showNotificationDeniedAlert = false
    @State private var showNameEdit = false
    @State private var editingName: String = ""

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    private var profile: UserProfile? { profiles.first }

    private var totalEntriesCount: Int { allEntries.count }

    private var daysTracked: Int {
        let dates = Set(allEntries.map { Calendar.current.startOfDay(for: $0.date) })
        return dates.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Profile Card
                    ProfileCard(
                        profile: profile,
                        daysTracked: daysTracked,
                        totalEntries: totalEntriesCount,
                        mode: mode,
                        onNameTap: {
                            editingName = profile?.name ?? ""
                            showNameEdit = true
                        }
                    )

                    // MARK: - Section: 偏好設定
                    SectionHeader(title: AppStrings.Profile.settingsSection(mode))

                    GroupedCard {
                        SettingsRow(
                            icon: "face.smiling",
                            title: AppStrings.Profile.toneLabel(mode),
                            subtitle: mode.displayName,
                            action: { showToneSettings = true }
                        )

                        SettingsDivider()

                        SettingsRow(
                            icon: "paintpalette",
                            title: AppStrings.Profile.themeLabel(mode),
                            subtitle: "\(currentTheme.emoji) \(currentTheme.displayName)",
                            action: { showThemePicker = true }
                        )

                        SettingsDivider()

                        SettingsRow(
                            icon: "bell",
                            title: AppStrings.Profile.notificationsLabel(mode),
                            action: { handleNotificationsTap() }
                        )
                    }

                    // MARK: - Section: 身體資料
                    SectionHeader(title: AppStrings.Profile.bodyInfoSection(mode))

                    GroupedCard {
                        SettingsRow(
                            icon: "person.text.rectangle",
                            title: AppStrings.Profile.bodyInfoLabel(mode),
                            subtitle: bodyInfoSubtitle,
                            action: { showBodyInfoSheet = true }
                        )
                    }

                    // MARK: - Section: 帳號
                    SectionHeader(title: AppStrings.Profile.accountSection(mode))

                    GroupedCard {
                        SettingsRow(
                            icon: "rectangle.portrait.and.arrow.right",
                            title: AppStrings.Account.signOut(mode),
                            iconColor: Theme.neonRed,
                            titleColor: Theme.neonRed,
                            showChevron: false,
                            action: { showSignOutAlert = true }
                        )

                        SettingsDivider()

                        SettingsRow(
                            icon: "trash",
                            title: AppStrings.Account.deleteAccount(mode),
                            iconColor: Theme.neonRed,
                            titleColor: Theme.neonRed,
                            showChevron: false,
                            action: { showDeleteAlert = true }
                        )
                    }

                    Spacer().frame(height: 20)
                }
            }
            .background(Theme.bg.ignoresSafeArea())
            .navigationTitle(AppStrings.Profile.navTitle(mode))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showToneSettings) {
                ToneSettingsSheet()
            }
            .sheet(isPresented: $showThemePicker) {
                ThemePickerSheet()
            }
            .sheet(isPresented: $showMealTimesSheet) {
                MealTimesSheet()
            }
            .sheet(isPresented: $showBodyInfoSheet) {
                BodyInfoSheet()
            }
            .alert(AppStrings.Account.signOutTitle(mode), isPresented: $showSignOutAlert) {
                Button(AppStrings.Account.cancel(mode), role: .cancel) { }
                Button(AppStrings.Account.confirm(mode), role: .destructive) {
                    Task { await performSignOut() }
                }
            } message: {
                Text(AppStrings.Account.signOutMessage(mode))
            }
            .alert(AppStrings.Account.deleteTitle(mode), isPresented: $showDeleteAlert) {
                Button(AppStrings.Account.cancel(mode), role: .cancel) { }
                Button(AppStrings.Account.confirm(mode), role: .destructive) {
                    Task { await performDeleteAccount() }
                }
            } message: {
                Text(AppStrings.Account.deleteMessage(mode))
            }
            .alert("改名", isPresented: $showNameEdit) {
                TextField("", text: $editingName)
                Button(AppStrings.Account.cancel(mode), role: .cancel) { }
                Button(AppStrings.Profile.saveButton(mode)) {
                    saveName()
                }
            } message: {
                Text("打個新名")
            }
            .alert("開啟通知", isPresented: $showNotificationDeniedAlert) {
                Button("去設定") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button(AppStrings.Account.cancel(mode), role: .cancel) { }
            } message: {
                Text("要喺設定開返通知先可以設提醒時間")
            }
        }
    }

    // MARK: - Computed

    private var currentTheme: ColorTheme {
        ColorTheme(rawValue: colorThemeRaw) ?? .amber
    }

    private var bodyInfoSubtitle: String? {
        guard let p = profile else { return nil }
        return "\(Int(p.heightCM))cm / \(String(format: "%.1f", p.weightKG))kg"
    }

    // MARK: - Actions

    private func saveName() {
        let trimmed = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let profile = profile else { return }
        profile.name = trimmed

        if let userId = authManager.userId {
            let syncManager = dataSyncManager
            Task(priority: .utility) {
                await syncManager.upsertProfile(profile, userId: userId)
            }
        }
    }

    private func handleNotificationsTap() {
        Task {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()

            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                await MainActor.run { showMealTimesSheet = true }
            case .notDetermined:
                let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
                await MainActor.run {
                    if granted == true {
                        showMealTimesSheet = true
                    } else {
                        showNotificationDeniedAlert = true
                    }
                }
            case .denied:
                await MainActor.run { showNotificationDeniedAlert = true }
            @unknown default:
                await MainActor.run { showMealTimesSheet = true }
            }
        }
    }

    private func clearLocalData() {
        for profile in profiles {
            modelContext.delete(profile)
        }
        for entry in allEntries {
            modelContext.delete(entry)
        }
        for weight in weightEntries {
            modelContext.delete(weight)
        }
        lastStreakCelebrationDay = 0
    }

    private func performSignOut() async {
        await authManager.signOut()
        withAnimation {
            appStateManager.state = .signIn
        }
    }

    private func performDeleteAccount() async {
        if let userId = authManager.userId {
            await dataSyncManager.deleteAllUserData(userId: userId)
        }
        clearLocalData()
        await authManager.signOut()
        withAnimation {
            appStateManager.state = .signIn
        }
    }
}

// MARK: - SettingsRow

private struct SettingsRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var iconColor: Color = Theme.neonGreen
    var titleColor: Color = .white
    var showChevron: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(iconColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(titleColor)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                    }
                }

                Spacer()

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SectionHeader

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Theme.textSecondary)
            .textCase(.none)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 4)
    }
}

// MARK: - GroupedCard

private struct GroupedCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - SettingsDivider

private struct SettingsDivider: View {
    var body: some View {
        Divider()
            .background(Theme.bgDivider)
            .padding(.leading, 58)
    }
}

// MARK: - ProfileCard

private struct ProfileCard: View {
    let profile: UserProfile?
    let daysTracked: Int
    let totalEntries: Int
    let mode: ToneMode
    var onNameTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Avatar + Name + Goal
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.neonGreen.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Text(String(profile?.name.prefix(1) ?? "?"))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.neonGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Button(action: onNameTap) {
                        HStack(spacing: 6) {
                            Text(profile?.name ?? "用戶")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)

                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textTertiary)
                        }
                    }
                    .buttonStyle(.plain)

                    Text(profile?.goal ?? "")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()
            }
            .padding(16)

            Divider()
                .background(Theme.bgDivider)

            // Stats strip
            HStack(spacing: 0) {
                StatItem(value: "\(profile?.currentStreak ?? 0)", label: "連續", icon: "🔥")

                StatDivider()

                StatItem(value: "\(profile?.longestStreak ?? 0)", label: "最長", icon: "🏆")

                StatDivider()

                StatItem(value: "\(daysTracked)", label: AppStrings.Profile.daysStat(mode), icon: "📅")

                StatDivider()

                StatItem(value: "\(totalEntries)", label: AppStrings.Profile.foodStat(mode), icon: "🍽️")

                StatDivider()

                StatItem(value: "\(profile?.dailyCalorieTarget ?? 0)", label: AppStrings.Profile.calStat(mode), icon: "🎯")
            }
            .padding(.vertical, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

// MARK: - StatItem

private struct StatItem: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - StatDivider

private struct StatDivider: View {
    var body: some View {
        Rectangle()
            .fill(Theme.bgDivider)
            .frame(width: 1, height: 32)
    }
}
