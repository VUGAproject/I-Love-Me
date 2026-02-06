import SwiftUI

struct ThemePickerView: View {
    @Binding var theme: ThemeOption

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Background")
                .font(.title2.bold())

            Picker("Theme", selection: $theme) {
                ForEach(ThemeOption.allCases) { option in
                    Text(option.name).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding()
        .background(.white.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
