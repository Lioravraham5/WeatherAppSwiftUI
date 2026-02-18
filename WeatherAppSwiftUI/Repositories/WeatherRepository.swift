//
//  WeatherRepository.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import Foundation

protocol WeatherRepository {
    func fetchWeather(for city: String) async throws -> WeatherResult
    func fetchWeatherForCities(_ cities: [String]) async throws -> WeatherListResult
}
