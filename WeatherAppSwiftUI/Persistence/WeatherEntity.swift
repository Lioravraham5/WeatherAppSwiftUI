//
//  WeatherEntity.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 17/02/2026.
//

import Foundation

extension WeatherEntity {

    func update(from weather: Weather) {
        self.cityName = weather.cityName
        self.temperature = weather.temperature
        self.minTemperature = weather.minTemperature
        self.maxTemperature = weather.maxTemperature
        self.humidity = Int16(weather.humidity)
        self.windSpeed = weather.windSpeed
        self.iconID = Int32(weather.iconID)
        self.weatherDescription = weather.weatherDescription
    }

    func toWeather() -> Weather {
        Weather(
            cityName: cityName ?? "",
            temperature: temperature,
            minTemperature: minTemperature,
            maxTemperature: maxTemperature,
            humidity: Int(humidity),
            windSpeed: windSpeed,
            iconID: Int(iconID),
            weatherDescription: weatherDescription ?? ""
        )
    }
}
