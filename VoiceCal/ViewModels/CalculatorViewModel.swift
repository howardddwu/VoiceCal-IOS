import SwiftUI
import AVFoundation

class CalculatorViewModel: ObservableObject {
    // MARK: - Properties
    
    // Model instances
    @Published private var model = CalculatorModel()
    @Published private var settings = CalculatorSettings()
    
    // Speech synthesizer for voice feedback
    private let synthesizer = AVSpeechSynthesizer()
    
    // Number formatter for consistent decimal display
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0  // Don't show decimals if not needed
        formatter.maximumFractionDigits = 8  // Limit decimal places to 8
        return formatter
    }()
    
    // MARK: - Published Properties (accessible by Views)
    
    var displayText: String { model.displayText }        // Current number or result
    var calculationString: String { model.calculationString }  // Full calculation expression
    
    // Dark mode toggle
    var isDarkMode: Bool {
        get { settings.isDarkMode }
        set { settings.isDarkMode = newValue }
    }
    
    // Language selection for speech
    var selectedLanguage: String {
        get { settings.selectedLanguage }
        set { settings.selectedLanguage = newValue }
    }
    
    // Speech rate adjustment
    var speechRate: Float {
        get { settings.speechRate }
        set { settings.speechRate = newValue }
    }
    
    // MARK: - Button Action Handlers
    
    /// Handles numeric input (0-9)
    func handleNumber(_ number: String) {
        // If there's a previous calculation (contains "="), start fresh
        if model.calculationString.contains("=") {
            model.calculationString = ""
            model.currentNumber = number
            model.displayText = number
        } else {
            if model.currentOperation == nil {
                // First number in calculation
                model.currentNumber = model.currentNumber == "0" ? number : model.currentNumber + number
                model.calculationString = model.currentNumber
            } else {
                // Subsequent number after operation
                model.currentNumber = model.currentNumber.isEmpty ? number : model.currentNumber + number
                
                // Update calculation string display
                if model.calculationString.isEmpty {
                    model.calculationString = model.currentNumber
                } else if model.currentNumber.count == 1 {
                    // First digit of new number
                    model.calculationString += number
                } else {
                    // Updating existing number
                    let components = model.calculationString.split(separator: " ")
                    if components.count >= 3 {
                        // Replace last number in expression
                        model.calculationString = components.dropLast().joined(separator: " ") + " " + model.currentNumber
                    } else {
                        model.calculationString = model.currentNumber
                    }
                }
            }
            model.displayText = model.currentNumber
        }
        speak(number)  // Provide voice feedback
    }
    
    /// Handles operations (+, -, ×, ÷)
    func handleOperation(_ operation: String) {
        // If continuing from previous result
        if model.calculationString.contains("=") {
            model.calculationString = "\(model.displayText) \(operation) "
            model.previousNumber = Double(model.displayText)
            model.currentNumber = ""
            model.currentOperation = operation
            speak(getOperationWord(operation))
            return
        }
        
        // Handle normal operation input
        if let current = Double(model.currentNumber) {
            if model.previousNumber != nil {
                // Calculate intermediate result
                if let result = model.calculate() {
                    model.previousNumber = result
                    model.displayText = formatNumber(result)
                    model.calculationString += " \(operation) "
                }
            } else {
                // First operation in calculation
                model.previousNumber = current
                model.calculationString = "\(model.currentNumber) \(operation) "
            }
            model.currentNumber = ""
        } else if model.calculationString.isEmpty && model.displayText != "0" {
            // Start new calculation with previous result
            model.calculationString = "\(model.displayText) \(operation) "
        } else if !model.calculationString.isEmpty {
            // Replace last operation if no number entered
            let components = model.calculationString.split(separator: " ")
            if components.count >= 2 {
                model.calculationString = components.dropLast().joined(separator: " ") + " \(operation) "
            }
        }
        model.currentOperation = operation
        speak(getOperationWord(operation))
    }
    
    /// Handles function buttons (C, =, ±, %, .)
    func handleFunction(_ function: String) {
        switch function {
        case "C":  // Clear all
            model.clear()
            speak("Clear")
            
        case "=":  // Calculate final result
            if let result = model.calculate() {
                model.calculationString += " = \(formatNumber(result))"
                model.displayText = formatNumber(result)
                model.currentNumber = formatNumber(result)
                model.previousNumber = nil
                model.currentOperation = nil
                speak("Equals \(formatNumber(result))")
            }
            
        case "±":  // Toggle negative/positive
            if let current = Double(model.currentNumber) {
                model.currentNumber = formatNumber(-current)
                model.displayText = model.currentNumber
                speak("Negative")
            }
            
        case "%":  // Convert to percentage
            if let current = Double(model.currentNumber) {
                model.currentNumber = formatNumber(current / 100)
                model.displayText = model.currentNumber
                speak("Percent")
            }
            
        case ".":  // Add decimal point
            if !model.currentNumber.contains(".") {
                model.currentNumber += model.currentNumber.isEmpty ? "0." : "."
                model.displayText = model.currentNumber
                speak("Point")
            }
            
        default:
            break
        }
    }
    
    // MARK: - Helper Functions
    
    /// Formats number for display
    private func formatNumber(_ number: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    /// Converts operation symbols to spoken words based on selected language
    private func getOperationWord(_ operation: String) -> String {
        switch selectedLanguage {
        case "zh-CN":  // Mandarin
            switch operation {
            case "+": return "加"
            case "-": return "减"
            case "×": return "乘以"
            case "÷": return "除以"
            default: return operation
            }
            
        case "zh-HK":  // Cantonese
            switch operation {
            case "+": return "加"
            case "-": return "減"
            case "×": return "乘"
            case "÷": return "除"
            default: return operation
            }
            
        case "es-ES":  // Spanish
            switch operation {
            case "+": return "más"
            case "-": return "menos"
            case "×": return "por"
            case "÷": return "entre"
            default: return operation
            }
            
        case "fr-FR":  // French
            switch operation {
            case "+": return "plus"
            case "-": return "moins"
            case "×": return "fois"
            case "÷": return "divisé par"
            default: return operation
            }
            
        default:  // English
            switch operation {
            case "+": return "plus"
            case "-": return "minus"
            case "×": return "times"
            case "÷": return "divided by"
            default: return operation
            }
        }
    }
    
    /// Speaks the given text using current language and speed settings
    private func speak(_ text: String) {
        // Handle special cases for function buttons
        let textToSpeak = switch text {
        case "C":
            switch selectedLanguage {
            case "zh-CN": "清除"
            case "zh-HK": "清除"
            case "es-ES": "borrar"
            case "fr-FR": "effacer"
            default: "clear"
            }
        case ".":
            switch selectedLanguage {
            case "zh-CN": "点"
            case "zh-HK": "點"
            case "es-ES": "punto"
            case "fr-FR": "point"
            default: "point"
            }
        case "=":
            switch selectedLanguage {
            case "zh-CN": "等于"
            case "zh-HK": "等於"
            case "es-ES": "igual"
            case "fr-FR": "égal"
            default: "equals"
            }
        default: text
        }
        
        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: settings.selectedLanguage)
        utterance.rate = settings.speechRate
        synthesizer.speak(utterance)
    }
} 
