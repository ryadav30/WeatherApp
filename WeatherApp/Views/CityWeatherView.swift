import SwiftUI

struct CityWeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                selectedCityHeader
                weatherContent
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 140)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity)
        .background {
            WeatherBackgroundView(
                cityName: viewModel.selectedCity,
                weatherData: viewModel.weatherData
            )
            .ignoresSafeArea()
        }
        .task {
            await viewModel.loadWeatherIfNeeded()
        }
    }

    private var selectedCityHeader: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Selected City")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.74))

                Text(viewModel.selectedCity)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            Image(systemName: "location.fill")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(Color.white.opacity(0.14), in: Circle())
        }
        .padding(18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var weatherContent: some View {
        if viewModel.isLoading {
            ProgressView("Loading weather...")
                .tint(.white)
                .foregroundStyle(.white)
                .padding(.top, 80)
        } else if let errorMessage = viewModel.errorMessage {
            ErrorStateView(
                message: errorMessage,
                retryAction: { Task { await viewModel.refreshWeather() } }
            )
        } else if let weatherData = viewModel.weatherData {
            WeatherSummaryCard(weatherData: weatherData)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
        }
    }
}

private struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundStyle(.yellow)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Button("Try Again", action: retryAction)
                .buttonStyle(.borderedProminent)
                .tint(.white.opacity(0.2))
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)
        )
    }
}

private struct WeatherBackgroundView: View {
    let cityName: String
    let weatherData: WeatherData?

    var body: some View {
        let style = weatherData?.backgroundStyle ?? .cloudy

        ZStack {
            Image(CityBackgroundProvider.imageName(for: cityName))
                .resizable()
                .scaledToFill()
                .clipped()

            LinearGradient(
                colors: overlayColors(for: style),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [.clear, .black.opacity(0.45)],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    private func overlayColors(for style: WeatherBackgroundStyle) -> [Color] {
        switch style {
        case .sunny:
            return [
                Color.orange.opacity(0.18),
                Color.yellow.opacity(0.10),
                Color.black.opacity(0.15)
            ]
        case .rainy:
            return [
                Color.blue.opacity(0.20),
                Color.black.opacity(0.24)
            ]
        case .snowy:
            return [
                Color.white.opacity(0.10),
                Color.cyan.opacity(0.06),
                Color.black.opacity(0.14)
            ]
        case .cloudy:
            return [
                Color.gray.opacity(0.14),
                Color.black.opacity(0.22)
            ]
        }
    }
}
