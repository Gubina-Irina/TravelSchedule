//
//  StationListView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 24.03.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class StationListViewModel: ObservableObject {
    @Published var stations: [Station] = []
    @Published var displayedStations: [Station] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataProvider = DataProvider()
    private let city: City
    
    init(city: City) {
        self.city = city
    }
    
    func loadStations() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await dataProvider.getAllStations()
            
            var allStations: [Station] = []
            
            if let countries = response.countries {
                for country in countries {
                    if let regions = country.regions {
                        for region in regions {
                            if let settlements = region.settlements {
                                for settlement in settlements {
                                    if settlement.title == city.title,
                                       let stationsData = settlement.stations {
                                        for stationData in stationsData {
                                            if let title = stationData.title {
                                                let station = Station(
                                                    title: title,
                                                    code: stationData.codes?.yandex_code ?? "",
                                                    stationType: stationData.station_type
                                                )
                                                allStations.append(station)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            stations = allStations.sorted { $0.title < $1.title }
            displayedStations = stations
            isLoading = false
            
        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func searchStations(query: String) {
        if query.isEmpty {
            displayedStations = stations
        } else {
            displayedStations = stations.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }
}
