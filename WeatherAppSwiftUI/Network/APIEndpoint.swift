//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Lior.Avraham on 29/01/2026.
//

import Foundation

enum APIEndpoint {
    case currentWeather(city: String)
}

// MARK: - URL Construction
extension APIEndpoint {
    
    // Base URL of the OpenWeatherMap API.
    // This is the common root for all API endpoints.
    private var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    // Path component for the specific endpoint.
    // Different endpoints can return different paths.
    private var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        }
    }
    
    // Query parameters for the request.
    // These parameters are appended to the URL after the "?" symbol.
    // URLQueryItem is used to ensure proper URL encoding.
    private var queryItems: [URLQueryItem] {
        switch self {
        case .currentWeather(let city):
            return [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: ""),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang", value: "en")
            ]
        }
    }
    
    // Fully constructed URL for the endpoint.
    // Combines baseURL, path, and queryItems using URLComponents.
    // Returns nil if the URL is invalid.
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
    
    
}
