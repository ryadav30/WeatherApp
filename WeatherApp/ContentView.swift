//
//  ContentView.swift
//  WeatherApp
//
//  Created by Rohit on 2026-03-15.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        TabView {
            CityListView(weatherViewModel: viewModel)
                .tabItem {
                    Label("Cities", systemImage: "list.bullet")
                }

            CityWeatherView(viewModel: viewModel)
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
