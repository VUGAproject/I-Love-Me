import SwiftUI

enum ThemeOption: String, CaseIterable, Identifiable {
    case mattePink
    case matteBrown
    case matteCream
    case matteOlive

    var id: String { rawValue }

    var name: String {
        switch self {
        case .mattePink: return "Matte Pink"
        case .matteBrown: return "Matte Brown"
        case .matteCream: return "Matte Cream"
        case .matteOlive: return "Matte Olive"
        }
    }

    var color: Color {
        switch self {
        case .mattePink: return Color(red: 0.96, green: 0.82, blue: 0.86)
        case .matteBrown: return Color(red: 0.74, green: 0.62, blue: 0.53)
        case .matteCream: return Color(red: 0.96, green: 0.92, blue: 0.84)
        case .matteOlive: return Color(red: 0.78, green: 0.80, blue: 0.67)
        }
    }
}
