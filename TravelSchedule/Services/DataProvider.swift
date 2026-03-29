//
//  DataProvider.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 24.03.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - Protocols
protocol DataProviderProtocol {
    // Станции и города
    func getAllStations() async throws -> AllStations
    
    // Поиск и расписание
    func getSchedualBetweenStations(from: String, to: String, date: String, transportType: String?) async throws -> SchedualBetweenStations
    func getStationSchedule(station: String) async throws -> StationSchedule
    func getRouteStations(uid: String) async throws -> RouteStations
    
    // Геолокация
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity
    
    // Перевозчики и копирайт
    func getCarrierInfo(code: String) async throws -> CarrierInfo
    func getCopyright() async throws -> Copyright
}

final class DataProvider: DataProviderProtocol {
    
    // MARK: - Properties
    private let client: Client
    private let apiKey: String
    
    // MARK: - Services (lazy)
    private lazy var allStationsService: AllStationsServiceProtocol = {
        AllStationsService(client: client, apikey: apiKey)
    }()
    
    private lazy var searchService: SchedualBetweenStationsServiceProtocol = {
        SchedualBetweenStationsService(client: client, apikey: apiKey)
    }()
    
    private lazy var stationScheduleService: StationScheduleServiceProtocol = {
        StationScheduleService(client: client, apikey: apiKey)
    }()
    
    private lazy var routeStationsService: RouteStationsServiceProtocol = {
        RouteStationsService(client: client, apikey: apiKey)
    }()
    
    private lazy var nearestStationsService: NearestStationsServiceProtocol = {
        NearestStationsService(client: client, apikey: apiKey)
    }()
    
    private lazy var nearestCityService: NearestCityServiceProtocol = {
        NearestCityService(client: client, apikey: apiKey)
    }()
    
    private lazy var carrierInfoService: CarrierInfoServiceProtocol = {
        CarrierInfoService(client: client, apikey: apiKey)
    }()
    
    private lazy var copyrightService: CopyrightServiceProtocol = {
        CopyrightService(client: client, apikey: apiKey)
    }()
    
    // MARK: - Init
    init() {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
        self.apiKey = Constants.apiKey
    }
    
    // MARK: - Public Methods
    
    // 1. Все станции и города
    func getAllStations() async throws -> AllStations {
        return try await allStationsService.getAllStations()
    }
    
    // 2. Расписание между станциями
    func getSchedualBetweenStations(from: String, to: String, date: String, transportType: String? = "train") async throws -> SchedualBetweenStations {
        do {
                // 1. Пробуем только поезда
                return try await searchService.getSchedualBetweenStations(
                    from: from,
                    to: to,
                    date: date,
                    transportType: transportType
                )
                
            } catch {
                // 2. fallback — пробуем ВСЁ
                return try await searchService.getSchedualBetweenStations(
                    from: from,
                    to: to,
                    date: date,
                    transportType: nil
                )
            }
    }
    
    // 3. Расписание по станции
    func getStationSchedule(station: String) async throws -> StationSchedule {
        return try await stationScheduleService.getStationSchedule(station: station)
    }
    
    // 4. Список станций следования
    func getRouteStations(uid: String) async throws -> RouteStations {
        return try await routeStationsService.getRouteStations(uid: uid)
    }
    
    // 5. Ближайшие станции
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        return try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    // 6. Ближайший город
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCity {
        return try await nearestCityService.getNearestCity(lat: lat, lng: lng)
    }
    
    // 7. Информация о перевозчике
    func getCarrierInfo(code: String) async throws -> CarrierInfo {
        return try await carrierInfoService.getCarrierInfo(code: code)
    }
    
    // 8. Копирайт
    func getCopyright() async throws -> Copyright {
        return try await copyrightService.getCopyright()
    }
}
