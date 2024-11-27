import Foundation

struct CalculatorModel {
    var currentNumber: String = ""
    var previousNumber: Double?
    var currentOperation: String?
    var displayText: String = "0"
    var calculationString: String = ""
    
    mutating func clear() {
        currentNumber = ""
        previousNumber = nil
        currentOperation = nil
        displayText = "0"
        calculationString = ""
    }
    
    mutating func calculate() -> Double? {
        guard let prev = previousNumber,
              let current = Double(currentNumber),
              let operation = currentOperation else { return nil }
        
        switch operation {
        case "+": return prev + current
        case "-": return prev - current
        case "×": return prev * current
        case "÷": return current != 0 ? prev / current : nil
        default: return nil
        }
    }
}

struct CalculatorSettings {
    var isDarkMode: Bool = false
    var selectedLanguage: String = "en-US"
    var speechRate: Float = 0.5
    
    static let availableLanguages = [
        "en-US": "English",
        "es-ES": "Español",
        "fr-FR": "Français",
        "zh-CN": "中文",      // Mandarin (Simplified Chinese)
        "zh-HK": "廣東話"     // Cantonese (Hong Kong)
    ]
} 