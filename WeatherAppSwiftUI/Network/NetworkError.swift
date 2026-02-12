//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Lior.Avraham on 29/01/2026.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingFailed
    case unknown(Error)
}
