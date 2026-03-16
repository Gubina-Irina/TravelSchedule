//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Irina Gubina on 13.03.2026.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testFetch()
        }
    }
    func testFetch() {
        let testFetch = TestFetch()
        testFetch.testFetchStations()
        testFetch.testFetchSchedualBetweenStations()
        testFetch.testFetchStationScheduale()
        testFetch.testFetchRouteStation()
        testFetch.testFetchNearestCity()
        testFetch.testFetchCarrierInfo()
        testFetch.testFetchAllStations()
        testFetch.testFetchCopyright()
    }
}

#Preview {
    ContentView()
}
