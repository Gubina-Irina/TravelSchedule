//
//  StationListView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 24.03.2026.
//

import SwiftUI

struct StationListView: View {
    @StateObject private var viewModel: StationListViewModel
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    let city: City
    var onStationSelected: ((City, Station) -> Void)?
    
    init(city: City, onStationSelected: ((City, Station) -> Void)? = nil) {
        self.city = city
        self.onStationSelected = onStationSelected
        _viewModel = StateObject(wrappedValue: StationListViewModel(city: city))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Введите запрос", text: $searchText)
                    .textFieldStyle(.plain)
                    .onChange(of: searchText) { _, newValue in
                        viewModel.searchStations(query: newValue)
                    }
                if !searchText.isEmpty && viewModel.isLoading {
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
            
            if viewModel.isLoading {
                Spacer()
                ProgressView("Загрузка станций...")
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
                            await viewModel.loadStations()
                        }
                    }
                }
                Spacer()
            } else if viewModel.displayedStations.isEmpty && !searchText.isEmpty {
                Spacer()
                VStack {
                    Text("Станция не найдена")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(viewModel.displayedStations.enumerated()), id: \.element) { index, station in
                            Button(action: {
                                onStationSelected?(city, station)
                                dismiss()
                            }) {
                                HStack {
                                    Text(station.title)
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
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.stations.isEmpty {
                await viewModel.loadStations()
            }
        }
    }
}
