//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by Lior.Avraham on 29/01/2026.
//

import Foundation

final class WeatherAPIService {
    
    // URLSession instance used to perform network requests.
    private let session: URLSession
    
    // Initializes the service with a URLSession.
    // Parameter session: URLSession to be used. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches the current weather data for a given city.
    /// - Parameter city: Name of the city to fetch weather for.
    /// - Returns: WeatherResponseDTO containing raw weather data from the API.
    /// - Throws: NetworkError in case of networking, response, or decoding failures.
    func fetchCurrentWeather(city: String) async throws -> WeatherResponseDTO {
        
        let endpoint = APIEndpoint.currentWeather(city: city)
        
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        // Create a URLRequest from the URL, default HTTP method is GET
        let request = URLRequest(url: url)
        
        do {
            
            // Perform the network request asynchronously.
            // This call suspends execution until a response is received
            // without blocking the calling thread.
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Validate HTTP status code (2xx indicates success)
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // Decode the received JSON data into a DTO
            let decoder = JSONDecoder()
            let weatherDTO = try decoder.decode(WeatherResponseDTO.self, from: data)
            
            // Return the successfully decoded DTO
            return weatherDTO

        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw NetworkError.noInternet
            } else {
                throw NetworkError.unknown(error)
            }
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
}
