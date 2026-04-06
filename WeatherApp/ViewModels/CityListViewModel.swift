import Combine
import SwiftUI

@MainActor
final class CityListViewModel: ObservableObject {
    @Published var selectedCity: CityRowItem?

    let cities: [CityRowItem]

    init() {
        cities = [
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "London", imageName: "CityPhoto"),
            CityRowItem(name: "Vancouver", imageName: "CityPhoto"),
            CityRowItem(name: "Calgary", imageName: "CityPhoto"),
            CityRowItem(name: "Ottawa", imageName: "CityPhoto"),
            CityRowItem(name: "Montreal", imageName: "CityPhoto"),
            CityRowItem(name: "Waterloo", imageName: "CityPhoto"),
            CityRowItem(name: "Edmonton", imageName: "CityPhoto"),
            CityRowItem(name: "Winnipeg", imageName: "CityPhoto"),
            CityRowItem(name: "Halifax", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto"),
            CityRowItem(name: "Toronto", imageName: "CityPhoto")
        ]
    }
}
