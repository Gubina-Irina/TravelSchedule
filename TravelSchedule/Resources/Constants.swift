//
//  Constants.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 16.03.2026.
//

import Foundation

enum Constants {
    static let apiKey: String = {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("API Key not found in Info.plist")
        }
        return key
    }()
}
