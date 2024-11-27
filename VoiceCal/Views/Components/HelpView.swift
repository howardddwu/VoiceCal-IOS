import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .padding()
            }

            Text("Calculator Help")
                .font(.title)
                .padding()

            Text("• Tap numbers and operations to perform calculations\n• Each button press will speak the number or operation\n• Use the top menu to:\n  - Toggle dark/light mode\n  - Change language\n  - Adjust speaking speed\n• Clear button (C) resets the calculation")
                .padding()
                .padding()
        }
    }
}

#Preview {
    HelpView()
}
