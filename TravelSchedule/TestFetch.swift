//
//  TestFetch.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 16.03.2026.
//

import Foundation
import OpenAPIURLSession


final class TestFetch {
    private func createClient() -> Client {
        do {
            return Client(
                // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
                serverURL: try Servers.Server1.url(),
                // Указываем, какой транспорт использовать для отправки запросов
                transport: URLSessionTransport()
            )
        } catch {
            print("Error creating client: \(error)")
            fatalError("Failed to create client: \(error)")
        }
    }
    
    // Функция для тестового вызова API
    func testFetchStations() {
        // Создаём Task для выполнения асинхронного кода
        Task {
            do {
                // 1. Создаём экземпляр сгенерированного клиента
                let client = createClient()
                
                // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
                let service = NearestStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                
                // 3. Вызываем метод сервиса
                print("Fetching NearestStations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177, // Пример координат
                    lng: 30.319163, // Пример координат
                    distance: 50    // Пример дистанции
                )
                
                // 4. Если всё успешно, печатаем результат в консоль
                print("Successfully fetched nearest stations: \(stations)")
            } catch {
                // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
                //    она будет поймана здесь, и мы выведем её в консоль
                print("Error fetching nearest stations: \(error)")
                // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
            }
        }
    }
    
    func testFetchSchedualBetweenStations() {
        Task {
            do {
                let client = createClient()
                let service = SchedualBetweenStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching SchedualBetweenStations...")
                let schedualBetweenStations = try await service.getSchedualBetweenStations(
                    from: "s9600213",
                    to: "s9600215")
                print("Successfully fetched schedual between station: \(schedualBetweenStations)")
            } catch {
                print("Error fetching schedual between station: \(error)")
            }
        }
    }
    
    func testFetchStationScheduale() {
        Task {
            do {
                let client = createClient()
                let service = StationScheduleService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching StationSchedule...")
                let stationSchedule = try await service.getStationSchedule(station: "s9600213")
                print("Successfully fetched station schedule: \(stationSchedule)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    
    func testFetchRouteStation() {
        Task {
            do {
                let client = createClient()
                let service = RouteStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching RouteStation...")
                let routeStations = try await service.getRouteStations(uid: "038AA_tis")
                print("Successfully fetched route station: \(routeStations)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    
    func testFetchNearestCity() {
        Task {
            do {
                let client = createClient()
                let service = NearestCityService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching RouteStation...")
                let nearestCity = try await service.getNearestCity(
                    lat: 59.864177,
                    lng: 30.319163)
                print("Successfully fetched route station: \(nearestCity)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    
    func testFetchCarrierInfo() {
        Task {
            do {
                let client = createClient()
                let service = CarrierInfoService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching CarrierInfo...")
                let carrierInfo = try await service.getCarrierInfo(
                    code: "680")
                print ("Successfully fetch carrier info: \(carrierInfo)")
            } catch {
                print("Error fetching carrier info: \(error)")
            }
        }
    }
    
    func testFetchAllStations() {
        Task {
            do {
                let client = createClient()
                
                let service = AllStationsService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching AllStations...")
                let stationsList = try await service.getAllStations()
                let countries = stationsList.countries?.map(\.title) ?? []
                print("Successfully fetched allStations: \(countries)")
                let countriesCount = stationsList.countries?.count ?? 0
                print("Successfully fetched \(countriesCount) countries")
            } catch {
                print("Error fetching stationsList: \(error)")
            }
        }
    }
    
    func testFetchCopyright() {
        Task {
            do {
                let client = createClient()
                let service = CopyrightService(
                    client: client,
                    apikey: Constants.apiKey
                )
                print("Fetching Copyright...")
                let copyright = try await service.getCopyright()
                print ("Successfully fetch copyright: \(copyright)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
}
