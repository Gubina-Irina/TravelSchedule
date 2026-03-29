//
//  Carrier.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 26.03.2026.
//

import Foundation

struct Carrier: Identifiable, Hashable {
    let id = UUID()
    let code: Int
    let title: String
    let contacts: String?
    let url: String?
    let phone: String?
    let adress: String?
    let logo: String?
    let email: String?
    var trips: [Trip] = []
    
    var displayName: String {
        return title
    }
}

struct Trip: Identifiable, Hashable {
    let id = UUID()
    let departureDate: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let hasTransfer: Bool
    let transferInfo: String?
}
