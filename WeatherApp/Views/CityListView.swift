import SwiftUI

struct CityListView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @StateObject private var listViewModel = CityListViewModel()

    var body: some View {
        NavigationStack {
            List(listViewModel.cities) { city in
                HStack(spacing: 16) {
                    Image(CityBackgroundProvider.imageName(for: city.name))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )

                    Text(city.name)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Spacer()

                    if listViewModel.selectedCity == city {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.green)
                    }
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    select(city)
                }
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(Color.white.opacity(0.08))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background {
                ZStack {
                    Image("CityListBackground")
                        .resizable()
                        .scaledToFill()
                        .clipped()

                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.25),
                            Color.black.opacity(0.45)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .ignoresSafeArea()
            }
            .navigationTitle("City List")
        }
        .onAppear {
            syncSelection(with: weatherViewModel.selectedCity)
        }
        .onChange(of: weatherViewModel.selectedCity) { _, newValue in
            syncSelection(with: newValue)
        }
    }

    private func select(_ city: CityRowItem) {
        listViewModel.selectedCity = city
        weatherViewModel.selectedCity = city.name

        Task {
            await weatherViewModel.refreshWeather()
        }
    }

    private func syncSelection(with cityName: String) {
        listViewModel.selectedCity = listViewModel.cities.first(where: { $0.name == cityName })
    }
}

#Preview {
    CityListView(weatherViewModel: WeatherViewModel())
}
