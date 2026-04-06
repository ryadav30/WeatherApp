import SwiftUI

struct WeatherData {
    let city: String
    let iconCode: String?
    let temperatureC: Double
    let condition: String
    let description: String
    let humidityPercent: Int
    let windSpeedMS: Double

    var temperatureText: String {
        "\(Int(temperatureC.rounded()))°C"
    }

    var humidityText: String {
        "\(humidityPercent)%"
    }

    var windSpeedText: String {
        String(format: "%.1f m/s", windSpeedMS)
    }

    var iconURLString: String? {
        guard let iconCode, !iconCode.isEmpty else {
            return nil
        }
        return "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
    }

    var backgroundStyle: WeatherBackgroundStyle {
        let normalized = "\(condition) \(description)".lowercased()

        if normalized.contains("clear") || normalized.contains("sunny") {
            return .sunny
        }
        if normalized.contains("rain") || normalized.contains("drizzle") || normalized.contains("thunderstorm") {
            return .rainy
        }
        if normalized.contains("snow") {
            return .snowy
        }
        return .cloudy
    }
}

enum WeatherBackgroundStyle {
    case sunny
    case rainy
    case snowy
    case cloudy

    var gradientColors: [Color] {
        switch self {
        case .sunny:
            return [Color(red: 0.98, green: 0.69, blue: 0.29), Color(red: 0.95, green: 0.44, blue: 0.22)]
        case .rainy:
            return [Color(red: 0.15, green: 0.29, blue: 0.44), Color(red: 0.07, green: 0.14, blue: 0.24)]
        case .snowy:
            return [Color(red: 0.63, green: 0.77, blue: 0.90), Color(red: 0.85, green: 0.91, blue: 0.96)]
        case .cloudy:
            return [Color(red: 0.34, green: 0.42, blue: 0.55), Color(red: 0.18, green: 0.22, blue: 0.32)]
        }
    }

    var accentColor: Color {
        switch self {
        case .sunny:
            return Color.yellow
        case .rainy:
            return Color.blue
        case .snowy:
            return Color.white
        case .cloudy:
            return Color.gray
        }
    }
}
