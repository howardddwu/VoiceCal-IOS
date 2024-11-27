import SwiftUI

struct CalculatorGridView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    
    private let buttons: [[CalculatorButton.ButtonItem]] = [
        [.function("C"), .function("±"), .function("%"), .operation("÷")],
        [.number("7"), .number("8"), .number("9"), .operation("×")],
        [.number("4"), .number("5"), .number("6"), .operation("-")],
        [.number("1"), .number("2"), .number("3"), .operation("+")],
        [.number("0"), .function("."), .function("=")]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { item in
                        CalculatorButton(
                            item: item,
                            action: { handleButtonPress(item) }
                        )
                        .frame(
                            minWidth: item.title != "0" ? 80 : nil,
                            maxWidth: item.title == "0" ? .infinity : nil,
                            maxHeight: 80
                        )
                    }
                }
            }
        }
        .padding()
    }
    
    private func handleButtonPress(_ item: CalculatorButton.ButtonItem) {
        switch item {
        case .number(let num):
            viewModel.handleNumber(num)
        case .operation(let op):
            viewModel.handleOperation(op)
        case .function(let function):
            viewModel.handleFunction(function)
        }
    }
}

#Preview {
    CalculatorGridView(viewModel: CalculatorViewModel())
} 