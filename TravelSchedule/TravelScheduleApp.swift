//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 13.03.2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
