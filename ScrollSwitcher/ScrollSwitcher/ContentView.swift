import SwiftUI

struct ContentView: View {
    @State private var isNaturalScroll = ScrollToggler.shared.isNaturalScroll

    private var isRussian: Bool {
        Locale.current.language.languageCode?.identifier == "ru"
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Scroll Switcher")
                .font(.headline)

            if ScrollToggler.shared.isAvailable {
                Toggle(isRussian ? "Естественная прокрутка" : "Natural Scrolling", isOn: $isNaturalScroll)
                    .toggleStyle(.switch)
                    .onChange(of: isNaturalScroll) { newValue in
                        ScrollToggler.shared.isNaturalScroll = newValue
                    }
            } else {
                Text(isRussian ? "Не удалось загрузить настройки" : "Unable to load scroll settings")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Divider()

            Button(isRussian ? "Выход" : "Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .font(.caption)
        }
        .padding(16)
        .frame(minWidth: 200, idealWidth: 240)
    }
}
