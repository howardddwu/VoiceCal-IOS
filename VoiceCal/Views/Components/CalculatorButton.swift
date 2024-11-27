import SwiftUI

struct CalculatorButton: View {
    enum ButtonItem: Hashable {
        case number(String)
        case operation(String)
        case function(String)
        
        var title: String {
            switch self {
            case .number(let num): return num
            case .operation(let op): return op
            case .function(let fun): return fun
            }
        }
        
        func buttonColor(operationColor: Color, numberColor: Color, functionColor: Color) -> Color {
            switch self {
            case .number: return numberColor
            case .operation: return operationColor
            case .function: return functionColor
            }
        }
    }
    
    let item: ButtonItem
    let action: () -> Void
    
    private let operationColor = Color.orange
    private let numberColor = Color(UIColor.systemGray4)
    private let functionColor = Color(UIColor.systemGray2)
    
    var body: some View {
        Button(action: action) {
            Text(item.title)
                .font(.title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(item.buttonColor(
                    operationColor: operationColor,
                    numberColor: numberColor,
                    functionColor: functionColor
                ))
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        CalculatorButton(item: .number("1"), action: {})
        CalculatorButton(item: .operation("+"), action: {})
        CalculatorButton(item: .function("C"), action: {})
    }
    .padding()
    .frame(width: 100)
} 