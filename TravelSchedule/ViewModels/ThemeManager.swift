//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 28.03.2026.
//

import Foundation
import Combine
import UIKit

@MainActor
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}
