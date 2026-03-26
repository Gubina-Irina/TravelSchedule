//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 25.03.2026.
//

import Foundation
import SwiftUI
import Combine


class MainViewModel: ObservableObject {
    @Published var fromCity: City?
    @Published var fromStation: Station?
    @Published var toCity: City?
    @Published var toStation: Station?
    
    func setFrom(city: City, station: Station) {
        fromCity = city
        fromStation = station
    }
    
    func setTo(city: City, station: Station) {
        toCity = city
        toStation = station
    }
    
    func swapDirection() {
        let tempCity = fromCity
        fromCity = toCity
        toCity = tempCity
        
        let tempStation = fromStation
        fromStation = toStation
        toStation = tempStation
    }
}
