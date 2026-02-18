//
//  CityDetailsViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 09/02/2026.
//

import Foundation
import Combine

@MainActor
final class CityDetailsViewModel: ObservableObject {
    
    @Published var weather: Weather
    @Published var isLoading: Bool = false
    @Published var isOffline: Bool = false
    @Published var alertItem: AlertItem?
    
    private let repository: WeatherRepository
    private let cityName: String
    
    init(weather: Weather, repository: WeatherRepository, initialIsOffline: Bool) {
        self.weather = weather
        self.cityName = weather.cityName
        self.repository = repository
        self.isOffline = initialIsOffline
    }
    
    func refreshData() async {
        isLoading = true
        isOffline = false
        alertItem = nil
        
        do {
            let result = try await repository.fetchWeather(for: cityName)
            self.weather = result.weather
            self.isOffline = result.isFromCache
        } catch {
            handleNetworkError(error)
        }
        
        isLoading = false
    }
    
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
