//
//  SettingView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 28.03.2026.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Toggle("Темная тема", isOn: $themeManager.isDarkMode)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }.padding()
        Spacer()
        VStack(alignment: .center) {
            Text("Приложение использует API «Яндекс.Расписания»")
                .font(.system(size: 12))
                .frame(height: 14)
            Text("Версия 1.0 (beta)")
                .font(.system(size: 12))
                .frame(height: 14)
        }
    }
}

#Preview {
    SettingsView()
}
