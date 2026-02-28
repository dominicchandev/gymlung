//
//  MainTabView.swift
//  GymLung
//
//  Created by Chan Tin Lok on 25/2/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @AppStorage("toneMode") private var toneModeRaw: String = ToneMode.normal.rawValue
    @State private var selectedTab = 0

    private var mode: ToneMode { ToneMode(rawValue: toneModeRaw) ?? .normal }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePage()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("主頁")
                }
                .tag(0)

            ProgressPage()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text(AppStrings.Progress.tabLabel(mode))
                }
                .tag(1)

            ProfilePage()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(AppStrings.Profile.tabLabel(mode))
                }
                .tag(2)
        }
        .tint(Theme.neonGreen)
    }
}
