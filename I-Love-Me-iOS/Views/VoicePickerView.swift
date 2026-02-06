import SwiftUI

struct VoicePickerView: View {
    let starterVoiceOptions: [StarterVoiceOption]
    let voiceOptions: [VoiceOption]
    @Binding var selectedVoice: VoiceOption?

    var body: some View {
        let availableStarters = starterVoiceOptions.compactMap { starter -> StarterVoiceOption? in
            starter.voice == nil ? nil : starter
        }
        let unavailableLabels = starterVoiceOptions
            .filter { $0.voice == nil }
            .map { $0.label }

        VStack(alignment: .leading, spacing: 12) {
            Text("Voice")
                .font(.title2.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text("Starter voices")
                    .font(.subheadline.weight(.semibold))

                if availableStarters.isEmpty {
                    Text("No starter voices installed")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Starter voices", selection: $selectedVoice) {
                        ForEach(availableStarters) { starter in
                            if let voice = starter.voice {
                                Text(starter.label).tag(Optional(voice))
                            }
                        }
                    }
                    .pickerStyle(.menu)
                }

                if !unavailableLabels.isEmpty {
                    Text("Not installed: \(unavailableLabels.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Divider()

            if voiceOptions.isEmpty {
                Text("No voices available")
                    .font(.subheadline)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("All system voices")
                        .font(.subheadline.weight(.semibold))
                    Picker("All voices", selection: $selectedVoice) {
                        ForEach(voiceOptions) { voice in
                            Text("\(voice.name) (\(voice.locale))").tag(Optional(voice))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
