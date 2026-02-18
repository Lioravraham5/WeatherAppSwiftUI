//
//  WeatherRepositoryImpl.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import Foundation

// Concrete implementation of WeatherRepository.
// Coordinates between remote (API) and local (Core Data) data sources.
final class WeatherRepositoryImpl: WeatherRepository {
    
    // Remote data source responsible for network calls.
    private let apiService: WeatherAPIService
    // Local data source responsible for caching and persistence.
    private let localDataSource: WeatherLocalDataSource
    
    init(apiService: WeatherAPIService = WeatherAPIService(),
         localDataSource: WeatherLocalDataSource = WeatherCoreDataDataSource()
    ) {
        self.apiService = apiService
        self.localDataSource = localDataSource
    }
    
    // MARK: - Single City
    
    // Fetches weather for a single city.
    // 1. Try fetching from the API.
    // 2. If successful, cache locally.
    // 3. If no internet, attempt to return cached data.
    func fetchWeather(for city: String) async throws -> WeatherResult {
        do {
            print("[WeatherRepository] Fetching weather from API for city: \(city)")
            
            // Fetch fresh data from remote API
            let dto = try await apiService.fetchCurrentWeather(city: city)
            // Convert DTO to Domain model
            let weather = dto.toWeather()
            
            print("[WeatherRepository] API success for city: \(city). Result: \(weather)")
            
            // Cache result locally for offline usage
            try await localDataSource.saveWeather(weather)
            
            print("[WeatherRepository] Cached weather for city: \(city)")
            
            return WeatherResult(
                weather: weather,
                isFromCache: false
            )
        } catch let error as NetworkError {
            // Fallback to cached data if no internet connection
            if case .noInternet = error {
                
                print("[WeatherRepository] No internet connection. Attempting to fetch from cache for city: \(city)")
                
                if let cached = try await localDataSource.fetchWeather(cityName: city) {
                    
                    print("[WeatherRepository] Cache hit for city: \(city). Cached result: \(cached)")
                    
                    return WeatherResult(
                        weather: cached,
                        isFromCache: true
                    )
                } else {
                    print("[WeatherRepository] Cache miss for city: \(city)")
                }
            }
            // Propagate other errors
            
            print("[WeatherRepository] Network error for city: \(city). Error: \(error)")
            
            throw error
        }
    }
    
    // Fetches weather for multiple cities concurrently.
    // 1. Perform concurrent API requests using TaskGroup.
    // 2. Sort results deterministically.
    // 3. Cache results locally.
    // 4. Fallback to cache if no internet is available.
    func fetchWeatherForCities(_ cities: [String]) async throws -> WeatherListResult {
        
        do {
            
            print("[WeatherRepository] Fetching weather for cities from API: \(cities)")
            
            var results: [Weather] = []
            
            // Structured concurrency: fetch all cities in parallel
            try await withThrowingTaskGroup(of: Weather.self) { group in
                for city in cities {
                    group.addTask {
                        // Fetch weather for each city independently
                        let dto = try await self.apiService.fetchCurrentWeather(city: city)
                        // Convert DTO to Domain model
                        let weather = await dto.toWeather()
                    
                        print("[WeatherRepository] API success for city: \(city). Result: \(weather)")
                        
                        return weather
                    }
                }
                
                for try await weather in group {
                    // Collect completed results as they finish
                    results.append(weather)
                }
            }
            
            // Ensure consistent alphabetical ordering
            let sorted = results.sorted {
                $0.cityName.localizedCaseInsensitiveCompare($1.cityName) == .orderedAscending
            }
            
            print("[WeatherRepository] API success for cities. Sorted result count: \(sorted.count)")
            
            // Cache results locally for offline support
            try await localDataSource.saveWeathers(sorted)
            
            print("[WeatherRepository] Cached weather list for cities: \(cities)")
            
            return WeatherListResult(
                weathers: sorted,
                isFromCache: false
            )
            
        } catch let error as NetworkError {
            
            // Offline fallback for multiple cities
            if case .noInternet = error {
                
                print("[WeatherRepository] No internet connection. Attempting to fetch from cache for cities: \(cities)")
                
                let cached = try await localDataSource.fetchWeathers(cityNames: cities)
                if !cached.isEmpty {
                    
                    print("[WeatherRepository] Cache hit for cities: \(cities). Cached result count: \(cached.count)")
                    print("[WeatherRepository] Cached results: \(cached)")
                    
                    return WeatherListResult(
                        weathers: cached,
                        isFromCache: true
                    )
                } else {
                    print("[WeatherRepository] Cache miss for cities: \(cities)")
                }
            }
            
            // Propagate error if no cache is available
            
            print("[WeatherRepository] Network error while fetching cities: \(cities). Error: \(error)")
            
            throw error
        }
    }
    
}
