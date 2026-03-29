//
//  CarrierListView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 26.03.2026.
//

import Foundation
import SwiftUI

struct CarrierListView: View {
    @StateObject private var viewModel = CarrierListViewModel()
    let route: TravelRoute
    
    var body: some View {
        VStack(spacing: 0) {
            Text(route.routeDisplayText)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .padding()
            
            Group {
                if viewModel.isLoading {
                    Spacer()
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Загрузка...")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Повторить") {
                            Task {
                                await viewModel.searchCarriers(
                                    fromStation: route.fromStation,
                                    toStation: route.toStation
                                )
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    Spacer()
                } else if viewModel.carriers.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "tram.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Перевозчики не найдены")
                            .font(.headline)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading,spacing: 0) {
                            ForEach(Array(viewModel.carriers.enumerated()), id: \.element.id) { index, carrier in
                                
                                CarrierRowView(carrier: carrier)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.searchCarriers(
                fromStation: route.fromStation,
                toStation: route.toStation
            )
        }
    }
}

#Preview {
    // Создаем тестовые города
    let moscow = City(title: "Москва", code: "c146", stations: nil)
    let spb = City(title: "Санкт-Петербург", code: "c2", stations: nil)
    
    // Создаем тестовые станции
    let moscowStation = Station(
        title: "Ленинградский вокзал",
        code: "s2006004",
        stationType: "train_station",
    )
    
    let spbStation = Station(
        title: "Московский вокзал",
        code: "s9602494",
        stationType: "train_station",
    )
    
    // Создаем маршрут
    let route = TravelRoute(
        fromCity: moscow,
        fromStation: moscowStation,
        toCity: spb,
        toStation: spbStation
    )
    CarrierListView(route: route)
    
}
