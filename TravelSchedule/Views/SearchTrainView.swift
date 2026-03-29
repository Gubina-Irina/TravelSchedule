//
//  MainView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 25.03.2026.
//

import SwiftUI

enum Route: Hashable {
    case from
    case to
    case carriers(route: TravelRoute)
}

struct SearchTrainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var navigationPath = NavigationPath()
    @State private var currentDirection: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.blue
                    .frame(height: 128)
                    .cornerRadius(20)
                
                HStack() {
                    VStack(spacing: 0) {
                        Button {
                            currentDirection = "from"
                            navigationPath.append(Route.from)
                        } label: {
                            SelectDestinationView(
                                city: viewModel.fromCity?.title ?? "",
                                station: viewModel.fromStation?.title ?? "",
                                placeholder: "Откуда"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            currentDirection = "to"
                            navigationPath.append(Route.to)
                        } label: {
                            SelectDestinationView(
                                city: viewModel.toCity?.title ?? "",
                                station: viewModel.toStation?.title ?? "",
                                placeholder: "Куда"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .cornerRadius(20)
                    
                    Button {
                        viewModel.swapDirection()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    
                }
                .padding()
            }
            .padding(.horizontal, 16)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { direction in
                CityListView { city in
                    navigationPath.append(city)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .from: CityListView {
                    city in navigationPath.append(city)
                }
                case .to : CityListView { city in
                    navigationPath.append(city) }
                case .carriers(let travelRoute):
                    CarrierListView(route: travelRoute)
                }
            }
            .navigationDestination(for: City.self) { city in
                StationListView(city: city) { selectedCity, selectedStation in
                    if currentDirection == "from" {
                        viewModel.fromCity = selectedCity
                        viewModel.fromStation = selectedStation
                    } else {
                        viewModel.toCity = selectedCity
                        viewModel.toStation = selectedStation
                    }
                    DispatchQueue.main.async {
                        navigationPath = NavigationPath()
                    }
                }
            }
            if viewModel.fromCity != nil && viewModel.toCity != nil {
                Button {
                    searchTrains()
                } label: {
                    Text("Найти")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 150, height: 60)
                        .background(.blue)
                        .cornerRadius(16)
                        .padding(.vertical, 16)
                }
            }
            
        }
    }
    private func searchTrains() {
        guard let fromCity = viewModel.fromCity,
              let fromStation = viewModel.fromStation,
              let toCity = viewModel.toCity,
              let toStation = viewModel.toStation else { return }
        
        let route = TravelRoute(
            fromCity: fromCity,
            fromStation: fromStation,
            toCity: toCity,
            toStation: toStation
        )
        
        navigationPath.append(Route.carriers(route: route))
    }
}

#Preview {
    SearchTrainView()
}
