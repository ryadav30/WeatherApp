import SwiftUI

enum CityBackgroundProvider {
    private static let fallbackAssetName = "CityPhoto"

    private static let assetNamesByCity: [String: String] = [
        "Toronto": "TorontoBackground",
        "London": "LondonBackground",
        "Vancouver": "VancouverBackground",
        "Calgary": "CalgaryBackground",
        "Ottawa": "OttawaBackground",
        "Montreal": "MontrealBackground",
        "Waterloo": "WaterlooBackground",
        "Edmonton": "EdmontonBackground",
        "Winnipeg": "WinnipegBackground",
        "Halifax": "HalifaxBackground"
    ]

    static func imageName(for city: String) -> String {
        assetNamesByCity[city] ?? fallbackAssetName
    }
}
