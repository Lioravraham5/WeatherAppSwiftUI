//
//  WeatherInfoRow.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 09/02/2026.
//

import SwiftUI

// Reusable row displaying a single weather detail.
struct WeatherInfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    WeatherInfoRow(title: "Humidity", value: "15%")
}
