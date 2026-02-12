//
//  WeatherRepositoryImpl.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    
    /// Service responsible for performing raw network requests
    private let apiService: WeatherAPIService
    
    init(apiService: WeatherAPIService = WeatherAPIService()) {
        self.apiService = apiService
    }
    
    /// Fetches weather data for a single city.
    ///
    /// - Parameter city: Name of the city.
    /// - Returns: A domain-level `Weather` model.
    /// - Throws: `NetworkError` if the request fails.
    ///
    /// This method:
    /// - Delegates the network call to `WeatherAPIService`
    /// - Converts the returned DTO into a clean domain model
    /// - Does NOT handle UI state or errors presentation
    func fetchWeather(for city: String) async throws -> Weather {
        let dto = try await apiService.fetchCurrentWeather(city: city)
        return dto.toWeather()
        
    }
    
    /// Fetches weather data for multiple cities concurrently.
    ///
    /// - Parameter cities: List of city names.
    /// - Returns: A sorted array of `Weather` objects.
    /// - Throws: The first encountered error (e.g. no internet, server error).
    ///
    /// Implementation details:
    /// - Uses `withThrowingTaskGroup` to perform all requests in parallel
    /// - If any city fetch fails, the entire operation fails ("all-or-nothing")
    /// - Results are sorted alphabetically for predictable UI ordering
    func fetchWeatherForCities(_ cities: [String]) async throws -> [Weather] {
        var results: [Weather] = []
        // Create a throwing task group where each task fetches weather for one city
        try await withThrowingTaskGroup(of: Weather.self) { group in
            
            // Add one concurrent task per city
            for city in cities {
                group.addTask {
                    try await self.fetchWeather(for: city)
                }
            }
            
            // Collect results as tasks complete (order of completion is not guaranteed)
            for try await weather in group {
                results.append(weather)
            }
        }
        
        // Sort results alphabetically for stable UI presentation
        return results.sorted {
            $0.cityName.localizedCaseInsensitiveCompare($1.cityName) == .orderedAscending
        }
    }
    
}
