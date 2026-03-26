//
//  CityListView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 23.03.2026.
//

import SwiftUI

struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    var onCitySelected: ((City) -> Void)?
    
    var body: some View {
            VStack(spacing: 0) {
                // Поле поиска
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Введите запрос", text: $searchText)
                        .textFieldStyle(.plain)
                        .onChange(of: searchText) { _, newValue in
                            viewModel.searchCities(query: newValue)
                        }
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .frame(width: 20, height: 22)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 7)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 16)
                
                // Контент
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Загрузка городов...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Повторить") {
                            Task {
                                await viewModel.loadCities()
                            }
                        }
                    }
                    Spacer()
                } else if viewModel.displayedCities.isEmpty && !searchText.isEmpty {
                    Spacer()
                    VStack {
                        Text("Город не найден")
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    Spacer()
                } else {
                    // Список городов
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.displayedCities, id: \.self) { city in
                                NavigationLink(value: city) {
                                    HStack {
                                        Text(city.title)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 24))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 19)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationDestination(for: City.self) { city in
                StationListView(city: city, onStationSelected: { selectedCity, selectedStation in
                    onCitySelected?(selectedCity)
                })
            }
            
            .task {
                if viewModel.cities.isEmpty {
                    await viewModel.loadCities()
                }
            }
        
    }
}

#Preview {
    NavigationStack {
        CityListView()
    }
}
