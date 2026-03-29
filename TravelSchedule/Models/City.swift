//
//  City.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 23.03.2026.
//

import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let code: String?
    let stations: [Station]?
}
