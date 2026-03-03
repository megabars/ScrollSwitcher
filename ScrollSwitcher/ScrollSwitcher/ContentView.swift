import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Scroll Switcher")
                .font(.headline)

            Toggle("Естественная прокрутка", isOn: Binding(
                get: { ScrollToggler.shared.isNaturalScroll },
                set: { ScrollToggler.shared.isNaturalScroll = $0 }
            ))
            .toggleStyle(.switch)

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .font(.caption)
        }
        .padding(16)
    }
}
