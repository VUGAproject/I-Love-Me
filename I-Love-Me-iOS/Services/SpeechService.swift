import AVFoundation

final class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var continuation: CheckedContinuation<Void, Never>?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func availableVoices() -> [VoiceOption] {
        AVSpeechSynthesisVoice.speechVoices().map { voice in
            VoiceOption(id: voice.identifier, name: voice.name, locale: voice.language)
        }
    }

    func defaultTrialVoice(from voices: [VoiceOption]) -> VoiceOption? {
        if let ng = voices.first(where: { $0.locale.lowercased().hasPrefix("en-ng") }) {
            return ng
        }
        return voices.first
    }

    func starterVoices(from voices: [VoiceOption]) -> [StarterVoiceOption] {
        let starters: [(label: String, localePrefix: String)] = [
            ("Confident Nigerian English", "en-ng"),
            ("Warm Ghanaian English", "en-gh"),
            ("Clear Kenyan English", "en-ke"),
            ("Rich South African English", "en-za")
        ]

        return starters.map { starter in
            let match = voices.first { $0.locale.lowercased().hasPrefix(starter.localePrefix) }
            return StarterVoiceOption(
                id: starter.localePrefix,
                label: starter.label,
                voice: match
            )
        }
    }

    func speakAndWait(_ text: String, voice: VoiceOption?) async {
        let utterance = AVSpeechUtterance(string: text)
        if let voice = voice {
            utterance.voice = AVSpeechSynthesisVoice(identifier: voice.id)
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0

        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            continuation = cont
            synthesizer.speak(utterance)
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        continuation?.resume()
        continuation = nil
    }
}
