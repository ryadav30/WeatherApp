import Foundation

struct OpenWeatherResponse: Decodable {
    let name: String
    let weather: [Condition]
    let main: Main
    let wind: Wind

    struct Condition: Decodable {
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case humidity
        }
    }

    struct Wind: Decodable {
        let speed: Double
    }
}
