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
                            IncomeRowView(income: income)
                                .padding()
                                .background(Color("backgroundColor"))
                                .cornerRadius(10)
                                .padding(.horizontal)
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
                    .font(.headline)
                    .foregroundColor(ColorPalette.textColor)

                Text("Fixed: \(income.isFixedIncome ? "Yes" : "No")")
                    .font(.subheadline)
                    .foregroundColor(ColorPalette.gray)
            }

            Spacer()

            Text(String(format: "%.2f %@", income.amount, "₺"))
                .font(.headline)
                .foregroundColor(ColorPalette.textColor)
        }
    }
}


struct IncomeBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeBreakdownView(presentSideMenu: .constant(false))
    }
}
