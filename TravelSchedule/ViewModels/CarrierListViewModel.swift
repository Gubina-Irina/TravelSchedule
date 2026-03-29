//
//  CarrierListViewModel.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 26.03.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CarrierListViewModel: ObservableObject {
    @Published var carriers: [Carrier] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataProvider = DataProvider()
    
    func searchCarriers(fromStation: Station, toStation: Station, date: Date = Date()) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            print("🔍 Поиск поездов от: \(fromStation.code) (\(fromStation.title))")
            print("🔍 до: \(toStation.code) (\(toStation.title))")
            print("📅 Дата: \(dateString)")
            
            let searchResult = try await dataProvider.getSchedualBetweenStations(
                from: fromStation.code,
                to: toStation.code,
                date: dateString,
                transportType: "train"
            )
            
            var carrierData: [Int: (carrier: Carrier, trips: [Trip])] = [:]
            
            if let segments = searchResult.segments {
                print("📊 Найдено сегментов: \(segments.count)")
                
                for segment in segments {
                    if let thread = segment.thread,
                       let carrierDataFromAPI = thread.carrier,
                       let carrierCode = carrierDataFromAPI.code {
                        
                        let trip = createTrip(from: segment)
                        
                        let carrier = Carrier(
                            code: carrierCode,
                            title: carrierDataFromAPI.title ?? "Неизвестный перевозчик",
                            contacts: carrierDataFromAPI.contacts,
                            url: carrierDataFromAPI.url,
                            phone: carrierDataFromAPI.phone,
                            adress: carrierDataFromAPI.address,
                            logo: carrierDataFromAPI.logo,
                            email: carrierDataFromAPI.email,
                            trips: []
                        )
                        if var existing = carrierData[carrierCode] {
                            existing.trips.append(trip)
                            carrierData[carrierCode] = existing
                        } else {
                            carrierData[carrierCode] = (carrier, [trip])
                        }
                    }
                }
            }
            // Преобразуем в массив Carrier с рейсами
            carriers = carrierData.map { code, value in
                var carrier = value.carrier
                // Сортируем рейсы по дате
                carrier.trips = value.trips.sorted { $0.departureDate < $1.departureDate }
                return carrier
            }.sorted { $0.title < $1.title }
            
            print("📊 Найдено перевозчиков: \(carriers.count)")
            
            if carriers.isEmpty {
                errorMessage = "Маршруты не найдены.\nПопробуйте:\n• Проверить правильность станций\n• Выбрать другую дату"
            }
            
            isLoading = false
            
        } catch {
            // Более детальная обработка ошибки
            let errorString = error.localizedDescription
            
            if errorString.contains("404") {
                errorMessage = "Маршруты не найдены.\nВозможно, прямых поездов между этими станциями нет."
            } else if errorString.contains("400") {
                errorMessage = "Неверный запрос. Проверьте коды станций."
            } else if errorString.contains("401") {
                errorMessage = "Ошибка авторизации. Проверьте API ключ."
            } else if errorString.contains("503") {
                errorMessage = "Сервер временно недоступен. Попробуйте позже."
            } else {
                errorMessage = "Ошибка: \(errorString)"
            }
            
            print("❌ Ошибка поиска: \(error)")
            isLoading = false
        }
    }
    
    private func createTrip(from segment: Components.Schemas.Segment) -> Trip {
        let departureDate = formatDate(segment.departure ?? "")
        let departureTime = formatTime(segment.departure ?? "")
        let arrivalTime = formatTime(segment.arrival ?? "")
        let duration = formatDuration(segment.duration ?? 0)
        
        
        return Trip(
            departureDate: departureDate,
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            duration: duration,
            hasTransfer: false,
            transferInfo: nil
        )
    }
    
    // MARK: - Форматирование
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoFormatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMMM"
        displayFormatter.locale = Locale(identifier: "ru_RU")
        
        return displayFormatter.string(from: date)
    }
    
    private func formatTime(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        guard let date = isoFormatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "HH:mm"
        
        return displayFormatter.string(from: date)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours) ч \(minutes) мин"
        } else if hours > 0 {
            return "\(hours) ч"
        } else {
            return "\(minutes) мин"
        }
    }
}
