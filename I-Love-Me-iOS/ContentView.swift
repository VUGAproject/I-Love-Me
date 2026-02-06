import SwiftUI

struct ContentView: View {
    @StateObject private var model = AppModel()

    var body: some View {
        ZStack {
            model.theme.color.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                            .accessibilityHidden(true)
                        Text("I Love ME")
                            .font(.largeTitle.bold())
                    }

                    ThemePickerView(theme: $model.theme)

                    AffirmationEditorView(
                        affirmations: $model.affirmations,
                        onPaste: model.addFromPaste
                    )

                    VoicePickerView(
                        starterVoiceOptions: model.starterVoiceOptions,
                        voiceOptions: model.voiceOptions,
                        selectedVoice: $model.selectedVoice
                    )

                    RecordingListView(
                        recordings: $model.recordingService.recordings,
                        isRecording: model.recordingService.isRecording,
                        onRecordToggle: model.toggleRecording
                    )

                    PlaybackControlsView(model: model)
                }
                .padding(20)
            }
        }
        .onAppear {
            model.refreshVoices()
        }
    }
}

private struct PlaybackControlsView: View {
    @ObservedObject var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Playback")
                .font(.title2.bold())

            Picker("Mode", selection: $model.playbackMode) {
                Text("TTS affirmations").tag(PlaybackMode.tts)
                Text("Recordings loop").tag(PlaybackMode.recordings)
            }
            .pickerStyle(.segmented)

            Toggle("Limit duration", isOn: $model.isDurationLimited)

            if model.isDurationLimited {
                HStack {
                    Text("Minutes: \(model.durationMinutes)")
                    Stepper("", value: $model.durationMinutes, in: 1...240)
                        .labelsHidden()
                }
            }

            HStack(spacing: 12) {
                Button(model.playbackManager.isPlaying ? "Stop" : "Start") {
                    model.togglePlayback()
                }
                .buttonStyle(.borderedProminent)

                if model.playbackManager.isPlaying {
                    Text(model.playbackManager.statusText)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
