import AVFoundation
import Foundation

struct RecordingItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL
    let createdAt: Date

    var name: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Recording \(formatter.string(from: createdAt))"
    }
}

@MainActor
final class RecordingService: NSObject, ObservableObject {
    @Published private(set) var recordings: [RecordingItem] = []
    @Published private(set) var isRecording: Bool = false

    private var recorder: AVAudioRecorder?
    private var currentRecordingURL: URL?

    func startRecording() {
        AudioSessionManager.configureRecordSession()

        let fileURL = Self.makeRecordingURL()
        currentRecordingURL = fileURL
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: fileURL, settings: settings)
            recorder?.record()
            isRecording = true
        } catch {
            print("Recording error: \(error)")
            recorder = nil
            currentRecordingURL = nil
            isRecording = false
        }
    }

    func stopRecording() {
        recorder?.stop()
        let recordedURL = currentRecordingURL
        recorder = nil
        currentRecordingURL = nil
        isRecording = false

        if let url = recordedURL {
            recordings.append(RecordingItem(url: url, createdAt: Date()))
        }
    }

    private static func makeRecordingURL() -> URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filename = "affirmation_\(Int(Date().timeIntervalSince1970)).m4a"
        return dir.appendingPathComponent(filename)
    }

}
