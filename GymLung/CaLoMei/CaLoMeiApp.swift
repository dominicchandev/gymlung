//
//  CaLoMeiApp.swift
//  CaLoMei
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData
import RevenueCat

@main
struct CaLoMeiApp: App {
    @State private var appStateManager = AppStateManager()
    @State private var authManager = AuthManager()
    @State private var dataSyncManager = DataSyncManager()

    init() {
        PurchaseManager.configure()
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            FoodEntry.self,
            WeightEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(
                for: schema,
                migrationPlan: CaLoMeiMigrationPlan.self,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRootContent()
                .environment(appStateManager)
                .environment(authManager)
                .environment(dataSyncManager)
                .preferredColorScheme(.dark)
                .task {
                    await PurchaseManager.shared.checkEntitlement()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
