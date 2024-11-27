import SwiftUI

struct DisplayView: View {
    let text: String
    let calculation: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // Calculation string
            Text(calculation)
                .font(.system(size: 24))
                .foregroundColor(.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            // Result
            Text(text)
                .font(.system(size: 40, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    VStack {
        DisplayView(text: "123.45", calculation: "100 + 23.45")
        DisplayView(text: "0", calculation: "")
    }
} 