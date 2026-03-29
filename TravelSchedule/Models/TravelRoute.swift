//
//  TravelRoute.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 26.03.2026.
//

import Foundation

struct TravelRoute: Hashable {
    let fromCity: City
    let fromStation: Station
    let toCity: City
    let toStation: Station
    
    var fromDisplayText: String {
        "\(fromCity.title) (\(fromStation.title))"
    }
    
    var toDisplayText: String {
        "\(toCity.title) (\(toStation.title))"
    }
    
    var routeDisplayText: String {
        "\(fromDisplayText) -> \(toDisplayText)"
    }
}
