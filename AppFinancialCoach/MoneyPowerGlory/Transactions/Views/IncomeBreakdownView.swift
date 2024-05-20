import SwiftUI

struct IncomeBreakdownView: View {
    @Binding var presentSideMenu: Bool
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Income Breakdown")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    if let userProfile = UserManager.shared.currentUser {
                        ForEach(userProfile.incomes, id: \.transactionId) { income in
                            Divider()
                            IncomeRowView(income: income)
                                .padding()
                        }
                    } else {
                        Text("No income to display yet...")
                    }
                }
                .padding()
            }
        }
    }
}

struct IncomeRowView: View {
    var income: IncomeModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(income.incomeName)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(Color("textColor"))
                
                Text("\(formattedDate())")
                    .font(.subheadline)
                    .foregroundColor(Color("textColor"))
                
                Text("Fixed: \(income.isFixedIncome ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(Color("textColor"))
            }

            Spacer()

            Text(String(format: "%.2f %@", income.amount, "₺"))
                .font(.footnote)
                .opacity(0.7)
                .lineLimit(1)
                .foregroundColor(Color("textColor"))
        }
        .navigationBarHidden(true)
    }
    
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: income.date)
    }
}


struct IncomeBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeBreakdownView(presentSideMenu: .constant(false))
    }
}
