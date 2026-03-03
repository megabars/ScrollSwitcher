import SwiftUI

struct ContentView: View {
    @State private var isNaturalScroll = ScrollToggler.shared.isNaturalScroll

    var body: some View {
        VStack(spacing: 12) {
            Text("Scroll Switcher")
                .font(.headline)

            Toggle("Естественная прокрутка", isOn: $isNaturalScroll)
                .toggleStyle(.switch)
                .onChange(of: isNaturalScroll) { newValue in
                    ScrollToggler.shared.isNaturalScroll = newValue
                }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .font(.caption)
        }
        .padding(16)
        .onAppear {
            isNaturalScroll = ScrollToggler.shared.isNaturalScroll
        }
    }
}
