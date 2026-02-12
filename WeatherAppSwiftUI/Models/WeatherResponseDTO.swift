//
//  WeatherResponseDTO.swift
//  WeatherApp
//
//  Created by Lior.Avraham on 29/01/2026.
//

import Foundation

// DTO = Data Transfer Object

// DTO representing the current weather API response
struct WeatherResponseDTO: Decodable {
    // City name
    let name: String
    // Array of weather conditions (usually contains one element)
    let weather: [WeatherConditionDTO]
    // Main weather measurements
    let main: MainWeatherDTO
    // Wind information
    let wind: WindDTO
}

// DTO representing a single weather condition
struct WeatherConditionDTO: Decodable {
    //Weather condition description (e.g. "light rain")
    let description: String
    // Weather icon identifier (e.g. 501)
    let id: Int
}

// DTO representing main temperature-related data
struct MainWeatherDTO: Decodable {
    // Current temperature
    let temp: Double
    // Minimum temperature
    let temp_min: Double
    // Maximum temperature
    let temp_max: Double
    // Humidity percentage
    let humidity: Int
}


// DTO representing wind-related data
struct WindDTO: Decodable {
    // Wind speed
    let speed: Double
}

// MARK: - WeatherResponseDTO to Weather
extension WeatherResponseDTO {
    func toWeather() -> Weather {
        return Weather(
            cityName: name,
            temperature: main.temp,
            minTemperature: main.temp_min,
            maxTemperature: main.temp_max,
            humidity: main.humidity,
            windSpeed: wind.speed,
            iconID: weather[0].id,
            weatherDescription: weather[0].description
        )
    }
}

