//
//  CarrierRowView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 27.03.2026.
//

import SwiftUI

struct CarrierRowView: View {
    let carrier: Carrier
    
    @State private var isExpanded = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            HStack() {
                if let logoUrl = carrier.logo, let url = URL(string: logoUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 38, height: 38)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 38, height: 38)
                                .cornerRadius(12)
                        case .failure:
                            Image(systemName: "train.side.front.car")
                        default:
                            Image(systemName: "train.side.front.car")
                        }
                    }
                } else {
                    Image(systemName: "train.side.front.car")
                }
                Text("\(carrier.title)")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            if !carrier.trips.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    if isExpanded {
                        ForEach(carrier.trips) { trip in
                            TripRowView(trip: trip)
                        }
                    } else {
                        ForEach(carrier.trips.prefix(2)) { trip in
                            TripRowView(trip: trip)
                        }
                    }
                    
                    if carrier.trips.count > 2 {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                            }
                        } label: {
                            HStack {
                                if isExpanded {
                                    Text("Свернуть")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 10))
                                        .foregroundColor(.blue)
                                } else {
                                    HStack(spacing: 4) {
                                        Text("и ещё \(carrier.trips.count - 2) рейса")
                                            .font(.system(size: 12))
                                            .foregroundColor(.blue)
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 10))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(24)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
        
    }
}
    
    
    struct TripRowView: View {
        let trip: Trip
        
        var body: some View {
            HStack {
                Text(trip.departureDate)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        
                        Text("\(trip.departureTime) — \(trip.arrivalTime)")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        Spacer()
                        
                        Text("(в пути: \(trip.duration))")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                    }
                    if trip.hasTransfer, let transferInfo = trip.transferInfo {
                        Text(transferInfo)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
