import SwiftUI

struct RecordingListView: View {
    @Binding var recordings: [RecordingItem]
    @Binding var selectedRecordingIDs: Set<UUID>
    let isRecording: Bool
    var onRecordToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recordings")
                .font(.title2.bold())

            Button(isRecording ? "Stop recording" : "Record affirmation") {
                onRecordToggle()
            }
            .buttonStyle(.bordered)

            if !recordings.isEmpty {
                Text("Selected \(selectedRecordingIDs.count) of \(recordings.count)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if recordings.isEmpty {
                Text("No recordings yet")
                    .font(.subheadline)
            } else {
                ForEach(recordings) { item in
                    Toggle(isOn: binding(for: item.id)) {
                        Text(item.name)
                    }
                    .toggleStyle(.switch)
                    .padding(8)
                    .background(.white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Text("If none selected, all recordings will play.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func binding(for id: UUID) -> Binding<Bool> {
        Binding(
            get: { selectedRecordingIDs.contains(id) },
            set: { isSelected in
                if isSelected {
                    selectedRecordingIDs.insert(id)
                } else {
                    selectedRecordingIDs.remove(id)
                }
            }
        )
    }
}
