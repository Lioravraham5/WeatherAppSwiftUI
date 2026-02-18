//
//  CityListViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import Foundation
import Combine


@MainActor
final class CityListViewModel: ObservableObject {
    
    @Published var citiesWeather: [Weather] = []
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    @Published var isOffline: Bool = false
    @Published var searchText: String = ""
    
    var filteredCitiesWeather: [Weather] {
        guard !searchText.isEmpty else {
            return citiesWeather
        }
        
        return citiesWeather.filter {
            $0.cityName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    
    private let repository: WeatherRepository
    
    
    // Static list of cities to display
    private let cities: [String] = [
        "Tel Aviv",
        "London",
        "New York",
        "Paris",
        "Tokyo",
        "Rome",
        "Berlin",
        "Barcelona",
        "Sydney",
        "Dubai",
        "Los Angeles",
        "Amsterdam",
        "Singapore",
        "Hong Kong",
        "Toronto"
    ]
    
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    // MARK: - Public API
    
    func loadCitiesWeather() async {
        isLoading = true
        isOffline = false
        alertItem = nil
        
        do {
            let result = try await repository.fetchWeatherForCities(cities)
            self.citiesWeather = result.weathers
            self.isOffline = result.isFromCache
            
        } catch {
            handleNetworkError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Error Handling
    
    private func handleNetworkError(_ error: Error) {
        guard let networkError = error as? NetworkError else {
            alertItem = AlertItem(
                title: "Unexpected Error",
                message: error.localizedDescription
            )
            return
        }
        
        switch networkError {
            
        case .noInternet:
            isOffline = true
            alertItem = AlertItem(
                title: "No Internet Connection",
                message: "Please check your connection. Showing last available data."
            )
            
        case .invalidURL:
            alertItem = AlertItem(
                title: "Internal Error",
                message: "Invalid request configuration."
            )
            
        case .invalidResponse:
            alertItem = AlertItem(
                title: "Server Error",
                message: "Invalid response from server."
            )
            
        case .serverError(let statusCode):
            alertItem = AlertItem(
                title: "Server Error",
                message: "Server returned error code \(statusCode)."
            )
            
        case .decodingFailed:
            alertItem = AlertItem(
                title: "Data Error",
                message: "Failed to parse weather data."
            )
            
        case .unknown(let error):
            alertItem = AlertItem(
                title: "Unknown Error",
                message: error.localizedDescription
            )
        }
    }
    
    
}
