import Combine
import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var selectedCity: String
    @Published private(set) var weatherData: WeatherData?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    let cities: [String]

    private let weatherService: WeatherService
    private var hasLoadedInitialWeather = false

    init(
        cities: [String]? = nil,
        weatherService: WeatherService? = nil
    ) {
        let resolvedCities = cities ?? AppConfig.cities
        let resolvedWeatherService = weatherService ?? WeatherService(apiKey: AppConfig.openWeatherAPIKey)

        self.cities = resolvedCities
        self.selectedCity = resolvedCities.first ?? "Toronto"
        self.weatherService = resolvedWeatherService
    }

    func loadWeatherIfNeeded() async {
        guard !hasLoadedInitialWeather else { return }
        hasLoadedInitialWeather = true
        await refreshWeather()
    }

    func refreshWeather() async {
        hasLoadedInitialWeather = true

        guard !weatherService.apiKey.isEmpty else {
            errorMessage = "OpenWeather API key is missing."
            weatherData = nil
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            weatherData = try await weatherService.fetchCurrentWeather(for: selectedCity)
        } catch {
            weatherData = nil
            errorMessage = "Unable to load weather for \(selectedCity). \(error.localizedDescription)"
        }

        isLoading = false
    }
}
