import SwiftUI

struct MenuBar: View {
    @Binding var isDarkMode: Bool
    @Binding var selectedLanguage: String
    @Binding var speechRate: Float
    @Binding var showingHelp: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: { isDarkMode.toggle() }) {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
            }
            
            Picker("Language", selection: $selectedLanguage) {
                ForEach(Array(CalculatorSettings.availableLanguages.keys), id: \.self) { key in
                    Text(CalculatorSettings.availableLanguages[key] ?? "")
                        .tag(key)
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            .frame(width: 100)
            
            Slider(value: $speechRate, in: 0.1...0.75)
                .frame(width: 100)
            
            Button(action: { showingHelp = true }) {
                Image(systemName: "questionmark.circle")
            }
        }
        .padding()
    }
}

#Preview {
    MenuBar(
        isDarkMode: .constant(true),
        selectedLanguage: .constant("en-US"),
        speechRate: .constant(0.5),
        showingHelp: .constant(false)
    )
} 
