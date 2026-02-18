//
//  OfflineBannerView.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 18/02/2026.
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text("Offline Mode – Showing last available data")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
        .foregroundColor(Color(.gray))
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    OfflineBannerView()
}
