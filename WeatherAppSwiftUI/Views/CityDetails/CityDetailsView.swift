//
//  CityDetailsView.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 09/02/2026.
//

import SwiftUI

struct CityDetailsView: View {
    
    @StateObject private var viewModel: CityDetailsViewModel
    
    init(weather: Weather, repository: WeatherRepository = WeatherRepositoryImpl()) {
        _viewModel = StateObject(
            wrappedValue: CityDetailsViewModel(
                weather: weather,
                repository: repository
            )
        )
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header (Icon + Temperature + Description)
                VStack(spacing: 12) {
                    Image(viewModel.weather.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("\(Int(viewModel.weather.temperature))°")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text(viewModel.weather.weatherDescription.capitalized)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                }
                
                
                // MARK: - Weather Details
                VStack(spacing: 16) {
                    WeatherInfoRow(
                        title: "High",
                        value: "\(Int(viewModel.weather.maxTemperature))°"
                    )
                    
                    WeatherInfoRow(
                        title: "Low",
                        value: "\(Int(viewModel.weather.minTemperature))°"
                    )
                    
                    WeatherInfoRow(
                        title: "Wind",
                        value: "\(Int(viewModel.weather.windSpeed)) km/h"
                    )
                    
                    WeatherInfoRow(
                        title: "Humidity",
                        value: "\(viewModel.weather.humidity)%"
                    )
                }
                .padding(.vertical, 8)
                
            }
        }
        .navigationTitle(viewModel.weather.cityName)
        .navigationBarTitleDisplayMode(.large)
        
        // Refresh button in navigation bar
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.refreshData()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        
        // Displays a loading indicator on top of the content
        // while weather data is being fetched.
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
        }
        
        // Presents an alert when an error occurs during data loading.
        // The alert is driven by an `AlertItem` provided by the ViewModel.
        .alert(item: $viewModel.alertItem) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        CityDetailsView(
            weather: Weather(
                cityName: "London",
                temperature: 18.5,
                minTemperature: 24,
                maxTemperature: 5,
                humidity: 8,
                windSpeed: 10.5,
                iconID: 800,
                weatherDescription: "Partly Cloudy"
            )
        )
    }
}

