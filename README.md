# 🌤 Weather App SwiftUI - iOS project
## Overview
WeatherAppSwiftUI is a clean and modern iOS application built with SwiftUI that integrates with the [OpenWeatherMap](https://openweathermap.org/api) public API to display real-time weather information for multiple cities.

https://github.com/user-attachments/assets/7c3fc805-3850-4b25-b529-4e6dc601079e

## 🔍 Features
### Main Screen – Cities Weather
- Displays a list of predefined cities.
- Search functionality for filtering cities.
- Loading indicator while fetching data.
- Offline banner when data is loaded from cache.
- Error alerts for network and server issues.
### City Details Screen
- Displays more detailed information about the selected city.
- Refresh button to reload weather data.
- Offline banner when showing cached data.
- Error alerts for network and server issues.

## 📴 Offline Support
- The app supports offline mode using Core Data.
- **When online:**
  - Weather data is fetched from OpenWeatherMap API.
  - Data is cached locally.
- **When offline:**
  - The app retrieves the last available weather data from Core Data.
  - An offline banner is displayed.

https://github.com/user-attachments/assets/740b4290-d374-4e98-8c7c-1b9207acdb10

**sqlite file:**

 <img src="https://github.com/user-attachments/assets/9cfc7977-6b70-49b5-912c-811fde185212" alt="Core data" style="width: 100%; height: 100%;">
 
## 🧩 Architecture
The project follows a clean MVVM architecture with repository pattern.
| Layer | Responsibility | Key Components |
|-------|---------------|----------------|
| **App** | Application entry point and dependency injection configuration | `WeatherApp`, root setup |
| **Network** | Handles API communication, request building, and response decoding | `WeatherAPIService`, `APIEndpoint`, `NetworkError` |
| **Models** | Data structures shared across layers | DTOs for API responses, Domain models used by the UI |
| **Persistence** | Core Data stack configuration and local caching layer | `PersistenceController`, `WeatherCoreDataDataSource` |
| **Repository** | Coordinates between remote API and local cache. Implements online-first strategy with offline fallback | `WeatherRepository`, `WeatherRepositoryImpl`, `WeatherResult`, `WeatherListResult` |
| **ViewModels** | Manage UI state, loading logic, error handling, and offline detection | `CityListViewModel`, `CityDetailsViewModel` |
| **Views** | SwiftUI presentation layer only. Contains no business logic | `CityListView`, `CityDetailsView`, `OfflineBannerView` |
### Data Flow
1. **ViewModel** requests data from the Repository
2. **Repository** fetches from:
   - Remote API first
   - Falls back to local Core Data cache if offline
3. Data is mapped from:
   - DTO → Domain model
4. UI updates reactively via `@Published` properties

## 🛠 Technical Decisions
| Aspect | Choice | Reason |
|--------|--------|--------|
| Architecture | MVVM + Repository Pattern | Ensures clear separation of concerns. ViewModels handle UI state, Repository abstracts data sources, and networking/persistence layers remain decoupled. Improves scalability, maintainability, and testability. |
| Local Storage | Core Data | Provides structured local persistence with efficient fetch and update capabilities. Enables reliable offline mode and better scalability compared to lightweight storage solutions. |
| Networking | URLSession (async/await) | Native Apple networking framework. Lightweight, dependency-free, and fully compatible with Swift Concurrency for modern asynchronous code. |
| Parallel Fetch | withThrowingTaskGroup | Uses structured concurrency to fetch multiple cities in parallel. Improves performance while maintaining clean error propagation and safe cancellation handling. |

## 🚀 How to Run
1. Clone the repository: ```https://github.com/Lioravraham5/WeatherAppSwiftUI.git```
2. Open the project in Xcode.
3. Navigate to `APIEndpoint.swift`.
4. Add your own OpenWeatherMap API key in the following line:
```
URLQueryItem(name: "appid", value: "YOUR_API_KEY_HERE")
```
5. If you do not have an API key, create one at: [OpenWeatherMap](https://openweathermap.org/api)
6. Build and run the project on Simulator or a physical device.
7. Ensure an active internet connection for the first launch.

## 👩‍💻 Developed by
**Lior Avraham** - iOS Developer · Passionate about clean code, cinematic design, and building amazing user experiences.

