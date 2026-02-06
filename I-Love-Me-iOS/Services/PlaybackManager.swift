import AVFoundation
import Foundation

@MainActor
final class PlaybackManager: ObservableObject {
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var statusText: String = "Idle"

    private var task: Task<Void, Never>?
    private var player: AVAudioPlayer?

    func startTTSLoop(texts: [String], voice: VoiceOption?, duration: TimeInterval?, speechService: SpeechService) {
        guard !texts.isEmpty else {
            statusText = "Add affirmations"
            return
        }
        stop()
        AudioSessionManager.configurePlaybackSession()
        isPlaying = true

        task = Task {
            let endDate = duration.map { Date().addingTimeInterval($0) }
            var index = 0
            while !Task.isCancelled {
                if let endDate, Date() >= endDate {
                    break
                }
                let text = texts[index % texts.count]
                statusText = "Speaking \(index + 1)"
                await speechService.speakAndWait(text, voice: voice)
                index += 1
                try? await Task.sleep(nanoseconds: 400_000_000)
            }
            stop()
        }
    }

    func startRecordingLoop(urls: [URL], duration: TimeInterval?) {
        guard !urls.isEmpty else {
            statusText = "Add recordings"
            return
        }
        stop()
        AudioSessionManager.configurePlaybackSession()
        isPlaying = true

        task = Task {
            let endDate = duration.map { Date().addingTimeInterval($0) }
            var index = 0
            while !Task.isCancelled {
                if let endDate, Date() >= endDate {
                    break
                }
                let url = urls[index % urls.count]
                statusText = "Playing recording \(index + 1)"
                await playRecording(url)
                index += 1
            }
            stop()
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        player?.stop()
        player = nil
        isPlaying = false
        statusText = "Idle"
    }

    private func playRecording(_ url: URL) async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.delegate = AudioPlayerDelegate {
                    cont.resume()
                }
                player?.play()
            } catch {
                print("Playback error: \(error)")
                cont.resume()
            }
        }
    }
}

private final class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinish()
    }
}
