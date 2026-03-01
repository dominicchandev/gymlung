//
//  HomePage.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData
import AVFoundation
import PhotosUI

struct HomePage: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query(sort: \FoodEntry.createdAt, order: .reverse) private var allEntries: [FoodEntry]
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @AppStorage("region") private var regionRaw: String = Region.deviceDefault.rawValue
    @State private var showAddFoodChoice = false
    @State private var showAddFood = false
    @State private var showCamera = false
    @State private var selectedDate = Date()
    @State private var selectedEntry: FoodEntry?
    @State private var showStreakCelebration = false
    @State private var streakCelebrationDay: Int = 0
    @State private var streakBrokenText: String?
    @State private var previousEntryCount = 0
    @State private var showPaywall = false
    @State private var scanner = FoodScannerManager()
    @State private var roastToast: String?
    @State private var photoPickerItem: PhotosPickerItem?

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }
    private var region: Region { Region(rawValue: regionRaw) ?? .hk }

    private var profile: UserProfile? { profiles.first }

    private var currentStreak: Int { profile?.currentStreak ?? 0 }

    // MARK: - All Dates (chronological, oldest → today, min 7)

    private var startDate: Date {
        Calendar.current.startOfDay(for: profile?.createdAt ?? Date())
    }

    private var allDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        // Always go back at least 6 days before today to fill 7 slots
        let earliest = min(startDate, calendar.date(byAdding: .day, value: -6, to: today) ?? today)
        var dates: [Date] = []
        var current = earliest
        while current <= today {
            dates.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        return dates
    }

    private var canScrollDates: Bool {
        allDates.count > 7
    }

    // MARK: - Filtered Entries

    private var selectedDateEntries: [FoodEntry] {
        let calendar = Calendar.current
        return allEntries.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var totalCalories: Int {
        selectedDateEntries.reduce(0) { $0 + $1.calories }
    }

    private var totalProtein: Double {
        selectedDateEntries.reduce(0) { $0 + $1.proteinG }
    }

    private var totalCarbs: Double {
        selectedDateEntries.reduce(0) { $0 + $1.carbsG }
    }

    private var totalFat: Double {
        selectedDateEntries.reduce(0) { $0 + $1.fatG }
    }

    private var calorieTarget: Int {
        profile?.dailyCalorieTarget ?? 2000
    }

    private var remainingCalories: Int {
        calorieTarget - totalCalories
    }

    private var calorieProgress: Double {
        guard calorieTarget > 0 else { return 0 }
        return min(Double(totalCalories) / Double(calorieTarget), 1.0)
    }

    private var isOverLimit: Bool {
        totalCalories > calorieTarget
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Top Bar (Cal AI style)
                    topBar

                    // 2. Week Calendar Strip
                    weekCalendarStrip

                    // 3. Non-milestone streak text (day 15+)
                    if currentStreak >= 15 {
                        let milestoneDays: Set<Int> = [30, 60, 90, 180, 365]
                        if !milestoneDays.contains(currentStreak) {
                            Text(AppStrings.Streak.nonMilestone(day: currentStreak, mode))
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                        }
                    }

                    // 4. Calorie Hero Card
                    calorieHeroCard

                    // 5. Three Macro Cards
                    macroCardsRow

                    // 6. Add Food Button
                    ActionButton(title: AppStrings.Home.addButton(mode)) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showAddFoodChoice = true
                        }
                    }
                    .padding(.horizontal, 20)

                    // 7. Recent Entries
                    recentEntriesSection

                    Spacer().frame(height: 20)
                }
            }
            .background(Theme.bg.ignoresSafeArea())
            .sheet(isPresented: $showAddFood, onDismiss: {
                checkStreakAfterFoodLog()
            }) {
                AddFoodSheet()
            }
            .sheet(item: $selectedEntry) { entry in
                FoodEntryEditSheet(entry: entry)
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView { image in
                    PurchaseManager.shared.recordScan()
                    handleCapturedImage(image)
                }
            }
            .onChange(of: photoPickerItem) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        PurchaseManager.shared.recordScan()
                        handleCapturedImage(image)
                    }
                    photoPickerItem = nil
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallSheet(trigger: .scanLimit(gender: profile?.gender ?? ""))
            }
            .overlay {
                if showAddFoodChoice {
                    addFoodChoiceOverlay
                        .transition(.opacity)
                        .zIndex(20)
                }
            }
            .overlay {
                if showStreakCelebration {
                    StreakCelebrationDialog(day: streakCelebrationDay) {
                        showStreakCelebration = false
                    }
                    .transition(.opacity)
                    .zIndex(10)
                }
            }
            .task {
                previousEntryCount = allEntries.count
                checkStreakOnLaunch()
            }
            .overlay {
                if let brokenText = streakBrokenText {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Text("💔")
                                .font(.system(size: 48))

                            Text(brokenText)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Theme.neonRed.opacity(0.7), lineWidth: 1)
                                )
                        )
                        .neonGlow(Theme.neonRed, radius: 16)
                        .padding(.horizontal, 40)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .overlay {
                if let roast = roastToast {
                    ZStack {
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation { roastToast = nil }
                            }

                        VStack(spacing: 12) {
                            Text(mode.roastEmoji)
                                .font(.system(size: 48))

                            Text(roast)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(mode.roastColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(mode.roastColor.opacity(0.6), lineWidth: 1)
                                )
                        )
                        .neonGlow(mode.roastColor, radius: 20)
                        .padding(.horizontal, 40)
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.85)))
                    .zIndex(30)
                }
            }
        }
    }

    // MARK: - Top Bar (Cal AI style)

    private var topBar: some View {
        HStack {
            // App branding
            Image("AppLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Theme.neonGreen)
                .frame(width: 28, height: 28)
            Text("CaLoMei")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            // Streak pill button
            Button {
                if currentStreak > 0 {
                    streakCelebrationDay = currentStreak
                    showStreakCelebration = true
                }
            } label: {
                HStack(spacing: 4) {
                    Text("🔥")
                        .font(.system(size: 14))
                    Text("\(currentStreak)")
                        .font(.system(size: 15, weight: .semibold).monospacedDigit())
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(Theme.bgCard)
                )
                .overlay(
                    Capsule().stroke(Theme.border, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Scrollable Calendar Strip

    private var weekCalendarStrip: some View {
        let calendar = Calendar.current
        let daySymbols = ["日", "一", "二", "三", "四", "五", "六"]
        let dates = allDates
        let todayID = "today"

        return ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(dates, id: \.self) { date in
                        let weekdayIndex = calendar.component(.weekday, from: date) - 1
                        let dayNumber = calendar.component(.day, from: date)
                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        let isToday = calendar.isDateInToday(date)
                        let isBeforeStart = date < startDate
                        let hasEntries = !isBeforeStart && allEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDate = date
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Text(daySymbols[weekdayIndex])
                                    .font(.system(size: 12))
                                    .foregroundColor(isBeforeStart ? Theme.textMuted : (isSelected ? .white : Theme.textTertiary))

                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(Theme.neonGreen)
                                            .frame(width: 32, height: 32)
                                    }

                                    Text("\(dayNumber)")
                                        .font(.system(size: 15, weight: isSelected ? .bold : .medium))
                                        .foregroundColor(
                                            isBeforeStart ? Theme.textMuted :
                                            (isSelected ? Theme.bg : (isToday ? Theme.neonGreen : .white))
                                        )
                                }
                                .frame(height: 32)

                                Circle()
                                    .fill(hasEntries ? Theme.neonGreen : Color.clear)
                                    .frame(width: 5, height: 5)
                            }
                            .frame(width: (UIScreen.main.bounds.width - 40 - 16) / 7)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.plain)
                        .disabled(isBeforeStart)
                        .id(isToday ? todayID : "\(date.timeIntervalSince1970)")
                    }
                }
                .padding(.horizontal, 8)
            }
            .scrollDisabled(!canScrollDates)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.bgCard)
            )
            .padding(.horizontal, 20)
            .onAppear {
                proxy.scrollTo(todayID, anchor: .trailing)
            }
        }
    }

    // MARK: - Calorie Hero Card

    private var calorieHeroCard: some View {
        HStack {
            // Left side — numbers
            VStack(alignment: .leading, spacing: 6) {
                Text("\(abs(remainingCalories))")
                    .font(.system(size: 36, weight: .bold).monospacedDigit())
                    .foregroundColor(isOverLimit ? Theme.neonRed : .white)
                    .contentTransition(.numericText())

                Text(AppStrings.Home.remaining(mode, overLimit: isOverLimit))
                    .font(.system(size: 13))
                    .foregroundColor(isOverLimit ? Theme.neonRed : Theme.textSecondary)

                HStack(spacing: 4) {
                    Text("\(totalCalories)")
                        .font(.system(size: 13, weight: .semibold).monospacedDigit())
                        .foregroundColor(Theme.neonGreen)
                    Text("/")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textTertiary)
                    Text("\(calorieTarget)")
                        .font(.system(size: 13, weight: .semibold).monospacedDigit())
                        .foregroundColor(Theme.textSecondary)
                    Text("kcal")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.top, 2)
            }

            Spacer()

            // Right side — compact ring
            ZStack {
                Circle()
                    .stroke(Theme.bgDivider, lineWidth: 10)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: calorieProgress)
                    .stroke(
                        isOverLimit ? Theme.neonRed : Theme.neonGreen,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: calorieProgress)
                    .neonGlow(isOverLimit ? Theme.neonRed : Theme.neonGreen, radius: 12)

                Text("🔥")
                    .font(.system(size: 28))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.bgCard)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Macro Cards Row

    private var macroCardsRow: some View {
        let proteinTarget = profile?.proteinTargetG ?? 120
        let carbsTarget = profile?.carbsTargetG ?? 250
        let fatTarget = profile?.fatTargetG ?? 65

        return HStack(spacing: 10) {
            MacroRingCard(
                label: "蛋白質",
                current: totalProtein,
                target: proteinTarget,
                color: Theme.macroProtein
            )
            MacroRingCard(
                label: "碳水",
                current: totalCarbs,
                target: carbsTarget,
                color: Theme.macroCarbs
            )
            MacroRingCard(
                label: "脂肪",
                current: totalFat,
                target: fatTarget,
                color: Theme.macroFat
            )
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Recent Entries Section

    private var recentEntriesSection: some View {
        VStack(spacing: 12) {
            Text(AppStrings.Home.records(mode))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            if selectedDateEntries.isEmpty {
                Text(emptyStateText())
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
            } else {
                List {
                    ForEach(selectedDateEntries) { entry in
                        FoodEntryCard(entry: entry, onRetry: entry.scanStatus == "failed" ? {
                            retryScanning(entry: entry)
                        } : nil)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if entry.scanStatus == nil {
                                    selectedEntry = entry
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteEntry(entry)
                                } label: {
                                    Label("刪除", systemImage: "trash")
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(height: CGFloat(selectedDateEntries.count) * 140)
                .scrollDisabled(true)
            }
        }
    }

    private func deleteEntry(_ entry: FoodEntry) {
        withAnimation {
            modelContext.delete(entry)
        }
    }

    // MARK: - Add Food Choice Overlay

    private var addFoodChoiceOverlay: some View {
        ZStack {
            // Dimmed background with subtle blur
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .background(.thinMaterial.opacity(0.3))
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showAddFoodChoice = false
                    }
                }

            // Choice cards
            HStack(spacing: 12) {
                // Search card
                addFoodOptionCard(
                    icon: "magnifyingglass",
                    label: "搜尋"
                ) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showAddFoodChoice = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        showAddFood = true
                    }
                }

                // Scan card
                addFoodOptionCard(
                    icon: "camera.fill",
                    label: "掃描"
                ) {
                    if PurchaseManager.shared.canScan {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showAddFoodChoice = false
                        }
                        requestCameraAndOpen()
                    } else {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showAddFoodChoice = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showPaywall = true
                        }
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if !PurchaseManager.shared.canScan {
                        ProBadge()
                            .padding(6)
                    }
                }
                .overlay(alignment: .bottom) {
                    if !PurchaseManager.shared.isPro {
                        dailyScanBadge
                    }
                }

                // Upload photo card
                if PurchaseManager.shared.canScan {
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        VStack(spacing: 14) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(Theme.neonGreen)

                            Text("相簿")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Theme.bgCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Theme.border, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .overlay(alignment: .bottom) {
                        dailyScanBadge
                    }
                    .onChange(of: photoPickerItem) { _, _ in
                        withAnimation(.easeOut(duration: 0.2)) {
                            showAddFoodChoice = false
                        }
                    }
                } else {
                    addFoodOptionCard(
                        icon: "photo.on.rectangle",
                        label: "相簿"
                    ) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showAddFoodChoice = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showPaywall = true
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        ProBadge()
                            .padding(6)
                    }
                    .overlay(alignment: .bottom) {
                        dailyScanBadge
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }

    private func addFoodOptionCard(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Theme.neonGreen)

                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.bgCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Theme.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var dailyScanBadge: some View {
        Text("今日 \(PurchaseManager.shared.remainingScans)/\(PurchaseManager.dailyScanLimit)")
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(PurchaseManager.shared.remainingScans > 0 ? Theme.textSecondary : Theme.neonRed)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(Theme.bg.opacity(0.85))
            )
            .padding(.bottom, 8)
    }

    private func requestCameraAndOpen() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                showCamera = true
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        showCamera = true
                    }
                }
            }
        case .denied, .restricted:
            // Open Settings so user can grant permission
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        @unknown default:
            break
        }
    }

    // MARK: - Streak Logic

    private func checkStreakOnLaunch() {
        guard let profile = profile else { return }
        if let event = StreakManager.checkOnAppLaunch(entries: allEntries, profile: profile) {
            if case .broken(let prev) = event {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    streakBrokenText = AppStrings.Streak.brokenByDuration(previousStreak: prev, mode)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation { streakBrokenText = nil }
                }
            }
        }
    }

    private func checkStreakAfterFoodLog() {
        guard let profile = profile else { return }
        // Only check if entries count actually increased (food was added, not cancelled)
        guard allEntries.count > previousEntryCount else { return }
        previousEntryCount = allEntries.count

        if let event = StreakManager.checkAfterFoodLog(entries: allEntries, profile: profile) {
            switch event {
            case .milestone(let day):
                streakCelebrationDay = day
                showStreakCelebration = true
            case .continued, .broken:
                break
            }
        }
    }

    // MARK: - Background Scan

    private func handleCapturedImage(_ image: UIImage) {
        guard let jpegData = image.jpegData(compressionQuality: 0.7) else { return }

        // Capture count before inserting so checkStreakAfterFoodLog sees the increase
        previousEntryCount = allEntries.count

        let entry = FoodEntry(
            name: "掃描中...",
            calories: 0,
            date: Date(),
            imageData: jpegData,
            scanStatus: "scanning"
        )
        modelContext.insert(entry)

        Task {
            await performScan(entry: entry, imageData: jpegData)
        }
    }

    private func retryScanning(entry: FoodEntry) {
        guard let imageData = entry.imageData else { return }
        entry.name = "掃描中..."
        entry.scanStatus = "scanning"

        Task {
            await performScan(entry: entry, imageData: imageData)
        }
    }

    private func performScan(entry: FoodEntry, imageData: Data) async {
        do {
            let result = try await scanner.scan(imageData: imageData, toneMode: mode, region: region)

            // Build name + components from result
            let items = result.food_items
            let components: [FoodComponent] = items.map { item in
                FoodComponent(
                    nameZH: item.name_zh,
                    nameEN: item.name_en,
                    calories: item.estimated_calories,
                    proteinG: item.protein_g,
                    carbsG: item.carbs_g,
                    fatG: item.fat_g,
                    portionDescription: item.portion_description,
                    confidence: item.confidence
                )
            }

            entry.name = items.map(\.name_zh).joined(separator: " + ")
            entry.calories = result.total_calories
            entry.proteinG = items.reduce(0) { $0 + $1.protein_g }
            entry.carbsG = items.reduce(0) { $0 + $1.carbs_g }
            entry.fatG = items.reduce(0) { $0 + $1.fat_g }
            entry.servingSize = items.count == 1 ? items[0].portion_description : "\(items.count)項"
            entry.components = components
            entry.scanStatus = nil

            // Show roast toast
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                roastToast = result.roast_comment
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation { roastToast = nil }
            }

            // Check streak
            checkStreakAfterFoodLog()
        } catch {
            entry.name = "掃描失敗"
            entry.scanStatus = "failed"
        }
    }

    // MARK: - Helpers

    private func emptyStateText() -> String {
        switch mode {
        case .normal: return "冇記錄 唔代表你冇食 👀"
        case .adult: return "冇記錄 唔代表你冇食 👀"
        case .gentle: return "仲未有記錄，食完記得記低呀～"
        case .twGanHua: return "沒有紀錄不代表你沒吃，自欺欺人是吧 👀"
        case .twAma: return "還沒吃東西嗎？不要餓肚子喔～"
        case .twYanShi: return "...空的，跟人生一樣"
        }
    }
}

// MARK: - Macro Ring Card

private struct MacroRingCard: View {
    let label: String
    let current: Double
    let target: Double
    let color: Color

    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(current / target, 1.0)
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Theme.bgDivider, lineWidth: 4)
                    .frame(width: 44, height: 44)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 44, height: 44)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }

            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)

            HStack(spacing: 2) {
                Text("\(Int(current))")
                    .font(.system(size: 14, weight: .bold).monospacedDigit())
                    .foregroundColor(.white)
                Text("/")
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textTertiary)
                Text("\(Int(target))g")
                    .font(.system(size: 11).monospacedDigit())
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.bgCard)
        )
    }
}

