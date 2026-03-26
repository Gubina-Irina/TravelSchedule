//
//  SelectDestinationView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 25.03.2026.
//

import Foundation
import SwiftUI

struct SelectDestinationView: View {
    let text: String
    let placeholder: String
    
    init(city: String, station: String, placeholder: String) {
        if city == "".trimmingCharacters(in: .whitespacesAndNewlines) && station == "".trimmingCharacters(in: .whitespacesAndNewlines) {
            self.text = placeholder
        } else {
            self.text = city + " (\(station))"
        }
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            Text(text)
                .padding(.vertical, 14)
                .padding([.leading], 16)
                .lineLimit(1)
                .foregroundColor(text != placeholder ? .black : .gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 48)
        .cornerRadius(20)
        .background(Color.white)
    }
    
}

#Preview {
    ZStack {
        Color.blue
        SelectDestinationView(city: "", station: "", placeholder: "Откуда")
    }
}

