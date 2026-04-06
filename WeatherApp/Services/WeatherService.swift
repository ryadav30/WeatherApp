import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidAPIKey
    case cityNotFound
    case serverError
    case decodingError
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidAPIKey:
            return "Invalid API key."
        case .cityNotFound:
            return "City not found."
        case .serverError:
            return "Weather server returned an error."
        case .decodingError:
            return "Failed to read weather data."
        case .networkError:
            return "Network connection error."
        }
    }
}

struct WeatherService {
    let apiKey: String

    func fetchCurrentWeather(for city: String) async throws -> WeatherData {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        return try await fetchCurrentWeather(from: url)
    }

    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> WeatherData {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }

        return try await fetchCurrentWeather(from: url)
    }

    private func fetchCurrentWeather(from url: URL) async throws -> WeatherData {
        let data = try await requestData(from: url)

        do {
            let decoded = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            return WeatherData(
                city: decoded.name,
                iconCode: decoded.weather.first?.icon,
                temperatureC: decoded.main.temp,
                condition: decoded.weather.first?.main ?? "Unknown",
                description: decoded.weather.first?.description ?? "Unknown",
                humidityPercent: decoded.main.humidity,
                windSpeedMS: decoded.wind.speed
            )
        } catch {
            throw WeatherError.decodingError
        }
    }

    private func requestData(from url: URL) async throws -> Data {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw WeatherError.networkError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.serverError
        }

        switch httpResponse.statusCode {
        case 200:
            return data
        case 401:
            throw WeatherError.invalidAPIKey
        case 404:
            throw WeatherError.cityNotFound
        default:
            throw WeatherError.serverError
        }
    }
}
