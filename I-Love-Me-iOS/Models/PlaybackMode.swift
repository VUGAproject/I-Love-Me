import Foundation

enum PlaybackMode: String, CaseIterable, Identifiable {
    case tts
    case recordings

    var id: String { rawValue }
}
