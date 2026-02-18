//
//  CityListView.swift
//  WeatherAppSwiftUI
//
//  Created by Lior.Avraham on 06/02/2026.
//

import SwiftUI

// Main screen displaying a searchable list of cities and their current weather.
struct CityListView: View {
    
    // ViewModel managing the screen state, data loading, filtering, and errors.
    // `@StateObject` ensures the ViewModel is created once and preserved across view re-renderings.
    @StateObject private var viewModel: CityListViewModel
    
    // Navigation path used by `NavigationStack` to manage programmatic navigation.
    // Stores navigation destinations in a type-safe way.
    @State private var path = NavigationPath()
    
    // Custom initializer that allows dependency injection of a `WeatherRepository`.
    init(repository: WeatherRepository = WeatherRepositoryImpl()) {
        _viewModel = StateObject(
            wrappedValue: CityListViewModel(repository: repository)
        )
    }
    
    var body: some View {
        // Root navigation container for the screen.
        // Uses a binding to `path` to enable programmatic navigation.
        NavigationStack(path: $path) {
            
            // List displaying weather information for all filtered cities.
            // The list automatically updates when `filteredCitiesWeather` changes.
            List(viewModel.filteredCitiesWeather) { weather in
                
                // Custom row view responsible only for presenting city weather data.
                CityRowView(weather: weather)
                // Ensures the entire row area is tappable,
                // not just the visible content.
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Programmatically pushes the selected weather item
                        // onto the navigation stack.
                        path.append(weather)
                    }
            }
            .safeAreaInset(edge: .top) {
                if viewModel.isOffline {
                    OfflineBannerView()
                }
            }
            .navigationTitle("Cities Weather")
            .navigationBarTitleDisplayMode(.large)
            
            // Search bar bound to the ViewModel.
            // Updates `searchText` in real time as the user types,
            // triggering filtering logic inside the ViewModel.
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search city"
            )
            
            // Navigation destination for a selected Weather item.
            // Each Weather pushed into the navigation path
            // is handled here and navigates to the details screen.
            .navigationDestination(for: Weather.self) { weather in
                // TODO: Replace with CityDetailsView(weather: weather)
                CityDetailsView(
                    weather: weather,
                    initialIsOffline: viewModel.isOffline
                )
            }
            
            // Displays a loading indicator on top of the content
            // while weather data is being fetched.
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                }
            }
            
            // Presents an alert when an error occurs during data loading.
            // The alert is driven by an `AlertItem` provided by the ViewModel.
            .alert(item: $viewModel.alertItem) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            // Loads the weather data when the view first appears.
            // Uses Swift Concurrency and runs once per view lifecycle.
            .task {
                await viewModel.loadCitiesWeather()
            }
        }
    }
}
#Preview {
    CityListView()
}
