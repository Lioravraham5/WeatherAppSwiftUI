//
//  WeatherAppSwiftUIApp.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import SwiftUI

@main
struct WeatherAppSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            CityListView()
//                .task {
//                                    let repository = WeatherRepositoryImpl()
//
//                                    do {
//                                        print("---- SINGLE CITY ----")
//                                        let weather = try await repository.fetchWeather(for: "London")
//                                        print(weather)
//
//                                        print("---- MULTIPLE CITIES ----")
//                                        let list = try await repository.fetchWeatherForCities(
//                                            ["London", "Paris", "New York"]
//                                        )
//                                        list.forEach { print($0) }
//
//                                        print("---- DONE ----")
//                                    } catch {
//                                        print("ERROR:", error)
//                                    }
//                                }
        }
    }
}
