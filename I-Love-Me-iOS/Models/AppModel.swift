import Foundation
import SwiftUI

@MainActor
final class AppModel: ObservableObject {
    @Published var affirmations: [Affirmation] = []
    @Published var playbackMode: PlaybackMode = .tts
    @Published var isDurationLimited: Bool = false
    @Published var durationMinutes: Int = 10
    @Published var theme: ThemeOption = .mattePink
    @Published var selectedVoice: VoiceOption?
    @Published private(set) var voiceOptions: [VoiceOption] = []
    @Published private(set) var starterVoiceOptions: [StarterVoiceOption] = []
    @Published var selectedRecordingIDs: Set<UUID> = []

    let playbackManager = PlaybackManager()
    let speechService = SpeechService()
    let recordingService = RecordingService()

    func refreshVoices() {
        voiceOptions = speechService.availableVoices()
        starterVoiceOptions = speechService.starterVoices(from: voiceOptions)
        if selectedVoice == nil {
            selectedVoice = speechService.defaultTrialVoice(from: voiceOptions)
        }
    }

    func addFromPaste(_ text: String) {
        let lines = text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        for line in lines {
            affirmations.append(Affirmation(text: line))
        }
    }

    func toggleRecording() {
        if recordingService.isRecording {
            if let item = recordingService.stopRecording() {
                selectedRecordingIDs.insert(item.id)
            }
        } else {
            recordingService.startRecording()
        }
    }

    func togglePlayback() {
        if playbackManager.isPlaying {
            playbackManager.stop()
            return
        }

        let duration: TimeInterval? = isDurationLimited ? TimeInterval(durationMinutes * 60) : nil

        switch playbackMode {
        case .tts:
            let texts = affirmations.map { $0.text }.filter { !$0.isEmpty }
            playbackManager.startTTSLoop(
                texts: texts,
                voice: selectedVoice,
                duration: duration,
                speechService: speechService
            )
        case .recordings:
            let recordings = recordingService.recordings
            let selected = recordings.filter { selectedRecordingIDs.contains($0.id) }
            let urls = (selected.isEmpty ? recordings : selected).map { $0.url }
            playbackManager.startRecordingLoop(
                urls: urls,
                duration: duration
            )
        }
    }
}
