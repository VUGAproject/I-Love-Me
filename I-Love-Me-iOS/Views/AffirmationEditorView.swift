import SwiftUI
import UIKit

struct AffirmationEditorView: View {
    @Binding var affirmations: [Affirmation]
    var onPaste: (String) -> Void

    @State private var newAffirmation: String = ""
    @State private var showPasteSheet: Bool = false
    @State private var pasteText: String = ""
    @State private var clipboardStatus: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Affirmations")
                .font(.title2.bold())

            HStack {
                TextField("Write an affirmation", text: $newAffirmation)
                Button("Add") {
                    let trimmed = newAffirmation.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    affirmations.append(Affirmation(text: trimmed))
                    newAffirmation = ""
                }
            }

            HStack(spacing: 12) {
                Button("Paste from clipboard") {
                    handleClipboardPaste()
                }

                Button("Paste list") {
                    showPasteSheet = true
                }
            }

            if !clipboardStatus.isEmpty {
                Text(clipboardStatus)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(affirmations) { item in
                HStack {
                    Text(item.text)
                    Spacer()
                    Button("Remove") {
                        affirmations.removeAll { $0.id == item.id }
                    }
                }
                .padding(8)
                .background(.white.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .sheet(isPresented: $showPasteSheet) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Paste affirmations")
                    .font(.title2.bold())
                Text("One per line")
                    .font(.subheadline)
                TextEditor(text: $pasteText)
                    .frame(minHeight: 200)
                    .border(Color.gray.opacity(0.3))
                HStack {
                    Button("Cancel") { showPasteSheet = false }
                    Spacer()
                    Button("Add all") {
                        onPaste(pasteText)
                        pasteText = ""
                        showPasteSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
    }

    private func handleClipboardPaste() {
        guard let text = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else {
            clipboardStatus = "Clipboard is empty"
            return
        }

        let count = text.split(whereSeparator: \.isNewline).count
        onPaste(text)
        clipboardStatus = "Added \(count) affirmation\(count == 1 ? "" : "s")"
    }
}
