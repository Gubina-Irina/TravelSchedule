//
//  CityListViewModel.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 23.03.2026.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class CityListViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var displayedCities: [City] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataProvider = DataProvider()
    private let popularCities = ["Москва", "Санкт-Петербург", "Сочи", "Казань", "Екатеринбург", "Новосибирск", "Владивосток"]
    
    func loadCities() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await dataProvider.getAllStations()
            
            var allCities: [City] = []
            
            if let countries = response.countries {
                for country in countries {
                    if let regions = country.regions {
                        for region in regions {
                            if let settlements = region.settlements {
                                for settlement in settlements {
                                    if let title = settlement.title {
                                        let city = City(
                                            title: title,
                                            code: settlement.codes?.yandex_code,
                                            stations: nil
                                        )
                                        allCities.append(city)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            self.cities = allCities.sorted { $0.title < $1.title }
            
            // Для начального отображения берем только популярные города
            self.displayedCities = self.cities.filter { popularCities.contains($0.title) }
            
            self.isLoading = false
            
        } catch {
            self.errorMessage = "Ошибка: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    // Метод для поиска по всем городам
    func searchCities(query: String) {
        if query.isEmpty {
            // Если поиск пустой, показываем популярные города
            displayedCities = cities.filter { popularCities.contains($0.title) }
        } else {
            // Ищем по всем городам
            displayedCities = cities.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }
}
