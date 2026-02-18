//
//  WeatherLocalDataSource.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 17/02/2026.
//

import Foundation

protocol WeatherLocalDataSource {
    func saveWeather(_ weather: Weather) async throws
    func saveWeathers(_ weathers: [Weather]) async throws

    func fetchWeather(cityName: String) async throws -> Weather?
    func fetchWeathers(cityNames: [String]) async throws -> [Weather]

    func deleteAll() async throws
}
