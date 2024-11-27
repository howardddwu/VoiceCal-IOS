import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var showingHelp = false
    
    var body: some View {
        VStack(spacing: 0) {
            MenuBar(
                isDarkMode: $viewModel.isDarkMode,
                selectedLanguage: $viewModel.selectedLanguage,
                speechRate: $viewModel.speechRate,
                showingHelp: $showingHelp
            )
            
            DisplayView(
                text: viewModel.displayText,
                calculation: viewModel.calculationString
            )
            
            CalculatorGridView(viewModel: viewModel)
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
    }
}

#Preview {
    CalculatorView()
} 