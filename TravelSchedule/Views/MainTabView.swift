//
//  TabView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 28.03.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            VStack {
                SearchTrainView()
            }
            .tabItem {
                Image("schedule")
            }
            VStack {
                SettingsView()
            }
            .tabItem {
                Image("settings")
            }
        }
    }
}

#Preview {
    MainTabView()
}
