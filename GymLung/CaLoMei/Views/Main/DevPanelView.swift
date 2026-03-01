//
//  DevPanelView.swift
//  CaLoMei
//
//  Development panel for debugging and testing.
//  Only visible in DEBUG builds.
//

import SwiftUI
import SwiftData
import RevenueCat

#if DEBUG
struct DevPanelView: View {
    @Environment(AppStateManager.self) private var appStateManager
    @Environment(AuthManager.self) private var authManager
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var allEntries: [FoodEntry]
    @Binding var isPresented: Bool

    @State private var selectedTab = 0
    @State private var showSignOutConfirmation = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Tab", selection: $selectedTab) {
                    Text("Info").tag(0)
                    Text("Logs").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedTab == 0 {
                    infoList
                } else {
                    LogListView()
                }
            }
            .navigationTitle("Dev Panel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isPresented = false }
                }
            }
            .alert("Sign Out?", isPresented: $showSignOutConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) { performSignOut() }
            }
            .overlay {
                if isLoading {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView().tint(.white)
                }
            }
        }
    }

    // MARK: - Info Tab

    private var infoList: some View {
        List {
            // MARK: - App State
            Section("App State") {
                LabeledContent("appStateManager.state") {
                    Text(appStateText)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                LabeledContent("authManager.state") {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(authStateColor)
                            .frame(width: 8, height: 8)
                        Text(authStateText)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // MARK: - Auth
            Section("Authentication") {
                if let userId = authManager.userId {
                    LabeledContent("User ID") {
                        Text(userId.uuidString)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .contextMenu {
                        Button {
                            UIPasteboard.general.string = userId.uuidString
                        } label: {
                            Label("Copy User ID", systemImage: "doc.on.doc")
                        }
                    }
                }

                if let email = authManager.userEmail {
                    LabeledContent("Email") {
                        Text(email)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // MARK: - Profile
            Section("User Profile") {
                if let profile = profiles.first {
                    LabeledContent("Name") {
                        Text(profile.name)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Onboarding Done") {
                        Image(systemName: profile.onboardingCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(profile.onboardingCompleted ? .green : .red)
                    }
                    LabeledContent("Goal") {
                        Text(profile.goal)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Calorie Target") {
                        Text("\(profile.dailyCalorieTarget) kcal")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Activity") {
                        Text(profile.activityLevel)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("No profile")
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: - Streak
            Section("Streak") {
                if let profile = profiles.first {
                    LabeledContent("Current Streak") {
                        Text("\(profile.currentStreak) days")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Longest Streak") {
                        Text("\(profile.longestStreak) days")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Last Log Date") {
                        Text(profile.lastLogDate?.formatted(date: .abbreviated, time: .shortened) ?? "nil")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("streakBrokenShown") {
                        Text(profile.streakBrokenShown ? "true" : "false")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("lastCelebrationDay") {
                        Text("\(UserDefaults.standard.integer(forKey: "lastStreakCelebrationDay"))")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }

                    Button("Reset Today's Streak") {
                        // Remove today's food entries so streak recalculates without today
                        let cal = Calendar.current
                        let today = cal.startOfDay(for: Date())
                        let todayEntries = allEntries.filter { cal.isDate($0.date, inSameDayAs: today) }
                        for entry in todayEntries {
                            modelContext.delete(entry)
                        }
                        StreakManager.calculateStreak(entries: allEntries.filter { !cal.isDate($0.date, inSameDayAs: today) }, profile: profile)
                        UserDefaults.standard.removeObject(forKey: "lastStreakCelebrationDay")
                    }

                    Button(role: .destructive) {
                        profile.currentStreak = 0
                        profile.longestStreak = 0
                        profile.lastLogDate = nil
                        profile.streakBrokenShown = false
                        UserDefaults.standard.removeObject(forKey: "lastStreakCelebrationDay")
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Reset All Streak Data")
                        }
                    }
                } else {
                    Text("No profile")
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: - Purchases
            Section("Purchases") {
                LabeledContent("isPro") {
                    Text(PurchaseManager.shared.isPro ? "true" : "false")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(PurchaseManager.shared.isPro ? .green : .secondary)
                }
                LabeledContent("Daily Scans Used") {
                    Text("\(PurchaseManager.shared.dailyScanCount) / \(PurchaseManager.dailyScanLimit)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                LabeledContent("Remaining Scans") {
                    Text(PurchaseManager.shared.isPro ? "∞" : "\(PurchaseManager.shared.remainingScans)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                Button("Reset Daily Scans") {
                    PurchaseManager.shared.resetDailyScans()
                }

                Button("Refresh Offerings") {
                    Task { await PurchaseManager.shared.loadOfferings() }
                }

                Button("Check Entitlement") {
                    Task { await PurchaseManager.shared.checkEntitlement() }
                }
            }

            // MARK: - UserDefaults
            Section {
                DisclosureGroup("UserDefaults Dump") {
                    let keys = ["toneMode", "region", "colorTheme", "dailyScanCount", "lastScanDate"]
                    ForEach(keys, id: \.self) { key in
                        VStack(alignment: .leading) {
                            Text(key)
                                .font(.caption.bold())
                            let val = UserDefaults.standard.value(forKey: key)
                            Text("\(String(describing: val ?? "nil" as Any))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 2)
                    }
                }
            } header: {
                Text("Local Persistence")
            }

            // MARK: - Actions
            Section("Actions") {
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Button(role: .destructive) {
                    showSignOutConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                }
                .disabled(isLoading)
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Computed

    private var appStateText: String {
        switch appStateManager.state {
        case .loading: return "loading"
        case .signIn: return "signIn"
        case .onboarding: return "onboarding"
        case .main: return "main"
        }
    }

    private var authStateText: String {
        switch authManager.state {
        case .idle: return "idle"
        case .loading: return "loading"
        case .signedIn: return "signedIn"
        case .signedOut: return "signedOut"
        }
    }

    private var authStateColor: Color {
        switch authManager.state {
        case .signedIn: return .green
        case .signedOut: return .red
        case .loading: return .orange
        case .idle: return .gray
        }
    }

    // MARK: - Actions

    private func performSignOut() {
        isLoading = true
        errorMessage = nil
        Task {
            await authManager.signOut()
            await MainActor.run {
                isLoading = false
                isPresented = false
            }
        }
    }
}

// MARK: - Log List View

struct LogListView: View {
    var logManager = LogManager.shared
    @State private var searchText = ""

    private var filteredLogs: [LogEntry] {
        let reversed = logManager.logs.reversed()
        if searchText.isEmpty { return Array(reversed) }
        return reversed.filter { $0.message.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search logs...", text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 8)

            if filteredLogs.isEmpty {
                ContentUnavailableView(
                    searchText.isEmpty ? "No Logs" : "No Results",
                    systemImage: "text.alignleft",
                    description: Text(searchText.isEmpty ? "Debug logs will appear here" : "No logs match \"\(searchText)\"")
                )
            } else {
                List {
                    ForEach(filteredLogs) { log in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.detailedTimestamp)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            Text(log.message)
                                .font(.caption.monospaced())
                                .textSelection(.enabled)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .contextMenu {
                            Button {
                                UIPasteboard.general.string = "[\(log.detailedTimestamp)] \(log.message)"
                            } label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }

            Divider()

            HStack {
                Text("\(logManager.logs.count) logs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(role: .destructive) {
                    logManager.clear()
                } label: {
                    Label("Clear All", systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

// MARK: - Dev Panel Button

struct DevPanelButton: View {
    @State private var showDevPanel = false
    @State private var position: CGPoint = .zero
    @State private var isDragging = false

    private let positionKey = "DevPanelButtonPosition"

    var body: some View {
        GeometryReader { geometry in
            Button {
                if !isDragging {
                    showDevPanel = true
                }
            } label: {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        let newX = min(max(18, value.location.x), geometry.size.width - 18)
                        let newY = min(max(18, value.location.y), geometry.size.height - 18)
                        position = CGPoint(x: newX, y: newY)
                    }
                    .onEnded { _ in
                        savePosition()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isDragging = false
                        }
                    }
            )
            .onAppear {
                if let saved = loadPosition() {
                    position = saved
                } else {
                    position = CGPoint(x: geometry.size.width - 26, y: geometry.size.height / 2)
                }
            }
            .onChange(of: geometry.size) { _, newSize in
                if position == .zero {
                    position = CGPoint(x: newSize.width - 26, y: newSize.height / 2)
                } else {
                    position = CGPoint(
                        x: min(max(18, position.x), newSize.width - 18),
                        y: min(max(18, position.y), newSize.height - 18)
                    )
                }
            }
        }
        .sheet(isPresented: $showDevPanel) {
            DevPanelView(isPresented: $showDevPanel)
        }
    }

    private func savePosition() {
        UserDefaults.standard.set([position.x, position.y], forKey: positionKey)
    }

    private func loadPosition() -> CGPoint? {
        guard let arr = UserDefaults.standard.array(forKey: positionKey) as? [CGFloat],
              arr.count == 2 else { return nil }
        return CGPoint(x: arr[0], y: arr[1])
    }
}
#endif
