import SwiftUI

struct RecordingListView: View {
    @Binding var recordings: [RecordingItem]
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

            if recordings.isEmpty {
                Text("No recordings yet")
                    .font(.subheadline)
            } else {
                ForEach(recordings) { item in
                    Text(item.name)
                        .padding(8)
                        .background(.white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
