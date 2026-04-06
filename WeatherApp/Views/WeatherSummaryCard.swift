import SwiftUI

struct WeatherSummaryCard: View {
    let weatherData: WeatherData

    var body: some View {
        VStack(spacing: 18) {
            heroSection
            detailsSection
        }
    }

    private var heroSection: some View {
        let style = weatherData.backgroundStyle

        return VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(weatherData.city)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text(weatherData.condition)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .layoutPriority(1)

                Spacer()

                WeatherIconView(iconURLString: weatherData.iconURLString, size: 64)
                    .frame(width: 72, height: 72)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            }

            Text(weatherData.temperatureText)
                .font(.system(size: 64, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(weatherData.description.capitalized)
                .font(.title3.weight(.medium))
                .foregroundStyle(.white.opacity(0.88))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: style.heroGradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Current Weather Details")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            DetailRow(label: "City name", value: weatherData.city)
            DetailRow(label: "Temperature", value: weatherData.temperatureText)
            DetailRow(label: "Weather condition", value: weatherData.description.capitalized)
            DetailRow(label: "Humidity", value: weatherData.humidityText)
            DetailRow(label: "Wind speed", value: weatherData.windSpeedText)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.78))

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct WeatherIconView: View {
    let iconURLString: String?
    let size: CGFloat

    var body: some View {
        Group {
            if let iconURLString, let url = URL(string: iconURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        fallbackIcon
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        fallbackIcon
                    @unknown default:
                        fallbackIcon
                    }
                }
            } else {
                fallbackIcon
            }
        }
        .frame(width: size, height: size)
    }

    private var fallbackIcon: some View {
        Image(systemName: "cloud.sun.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.white)
            .padding(8)
    }
}

private extension WeatherBackgroundStyle {
    var heroGradientColors: [Color] {
        switch self {
        case .sunny:
            return [
                Color(red: 0.98, green: 0.76, blue: 0.30).opacity(0.38),
                Color(red: 0.94, green: 0.48, blue: 0.22).opacity(0.26),
                Color.black.opacity(0.12)
            ]
        case .rainy:
            return [
                Color(red: 0.19, green: 0.36, blue: 0.57).opacity(0.40),
                Color(red: 0.08, green: 0.16, blue: 0.28).opacity(0.34),
                Color.black.opacity(0.18)
            ]
        case .snowy:
            return [
                Color(red: 0.78, green: 0.88, blue: 0.98).opacity(0.30),
                Color(red: 0.52, green: 0.66, blue: 0.82).opacity(0.22),
                Color.black.opacity(0.16)
            ]
        case .cloudy:
            return [
                Color(red: 0.45, green: 0.54, blue: 0.66).opacity(0.34),
                Color(red: 0.20, green: 0.26, blue: 0.38).opacity(0.26),
                Color.black.opacity(0.18)
            ]
        }
    }
}
