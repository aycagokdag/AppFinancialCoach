import SwiftUI

struct FinancesView: View {
    @Binding var presentSideMenu: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
//                Text("Finances")
//                    .font(.title)
//                    .foregroundColor(.black)
//                    .bold()
                
                NavigationLink(destination: IncomeBreakdownView(presentSideMenu: $presentSideMenu)) {
                    VStack {
                        Image(systemName: "chart.bar.xaxis")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 60, height: 60)
                           .foregroundColor(.black)
                        Text("Income Breakdown")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("View your income transactions")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: ExpenseBreakdownView(presentSideMenu: $presentSideMenu)) {
                    VStack {
                        Image(systemName: "chart.pie")
                           .resizable()
                           .scaledToFit()
                           .frame(width: 60, height: 60)
                           .foregroundColor(.black)
                        Text("Expense Breakdown")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("View your expense transactions")
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("")
            .navigationBarItems(leading:
                Button(action: {
                    presentSideMenu.toggle()
                }) {
                    Image(systemName: "text.justify.leading")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("textColor"))
                }
            )
        }
    }
}

struct FinancesView_Previews: PreviewProvider {
    static var previews: some View {
        FinancesView(presentSideMenu: .constant(false))
    }
}
