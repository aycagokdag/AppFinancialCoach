import SwiftUI

struct QueResultView: View {
    let riskLevel: Int
    @Binding var resultPresented: Bool

    
    var riskProfile: String {
        switch Double(riskLevel) {
            case 0...1:
                return "Low Risk Profile"
            case 1..<2.3:
                return "Medium Risk Profile"
            default:
                return "High Risk Profile"
            }
        }
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(riskProfile)")
                .font(.title)
                .padding()
            
            Spacer()
            
            Button(action: {
                   self.resultPresented = false // Set this binding to false to dismiss the current view
               }) {
                   Text("Back to Questions")
                   .foregroundColor(Color("gray")) // You can customize the color
                   .padding()
               }
            Spacer()
        }
        .navigationBarTitle("Result", displayMode: .inline)
    }
}
