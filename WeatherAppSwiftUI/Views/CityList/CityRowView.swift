//
//  CityRowView.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import SwiftUI

struct CityRowView: View {
    
    let weather: Weather
    
    var body: some View {
        HStack {
            // Left side: city name + description
            VStack(alignment: .leading, spacing: 4) {
                Text(weather.cityName)
                    .font(.headline)
                
                Text(weather.weatherDescription.capitalized)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Right side: temperature + icon
            HStack(spacing: 6) {
                Text("\(Int(weather.temperature))°")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Image(weather.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

#Preview {
    CityRowView(weather: Weather(
        cityName: "London",
        temperature: 18.5,
        minTemperature: 24,
        maxTemperature: 5,
        humidity: 8,
        windSpeed: 10.5,
        iconID: 800,
        weatherDescription: "Partly Cloudy")
    )
}
