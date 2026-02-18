//
//  Weather.swift
//  WeatherApp
//
//  Created by Lior.Avraham on 29/01/2026.
//

import Foundation


// Represents weather information for a specific city
struct Weather: Identifiable, Hashable {
    // The id is necessary because of the use of List in SwiftUI.
    let id = UUID()
    // City name
    let cityName: String
    // Current temperature
    let temperature: Double
    // Minimum temperature
    let minTemperature: Double
    // Maximum temperature
    let maxTemperature: Double
    // Humidity percentage
    let humidity: Int
    // Wind speed
    let windSpeed: Double
    // Weather icon identifier 
    let iconID: Int
    // Weather description
    let weatherDescription: String
}

extension Weather {
    
    var iconName: String {
        switch iconID {
        case 200...232:
            return "weather_thunderstorm"
        case 300...321:
            return "weather_drizzle"
        case 500...531:
            return "weather_rain"
        case 600...622:
            return "weather_snow"
        case 701...781:
            return "weather_fog"
        case 800:
            return "weather_clear"
        case 801...804:
            return "weather_cloudy"
        default:
            return "weather_fallback"
        }
    }
}

struct WeatherResult {
    let weather: Weather
    let isFromCache: Bool
}

struct WeatherListResult {
    let weathers: [Weather]
    let isFromCache: Bool
}

