import SwiftUI

struct FinancesView: View {
    @Binding var presentSideMenu: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Options").padding(.top, 20)) {
                    NavigationLink(destination: IncomeBreakdownView(presentSideMenu: $presentSideMenu)) {
                        Text("Income Breakdown")
                            .padding(.vertical, 8)
                    }
                    
                    NavigationLink(destination: ExpenseBreakdownView(presentSideMenu: $presentSideMenu)) {
                        Text("Expense Breakdown")
                            .padding(.vertical, 8)
                    }
                }
            }
            .listStyle(GroupedListStyle()) // This style groups the list content visually
            .navigationBarTitle("Finances", displayMode: .large)
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


#Preview {
    FinancesView(presentSideMenu: .constant(false))
}
