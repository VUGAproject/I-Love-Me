import Foundation

struct StarterVoiceOption: Identifiable, Equatable {
    let id: String
    let label: String
    let voice: VoiceOption?
}
