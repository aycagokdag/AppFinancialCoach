
import SwiftUI
import UIKit

struct ExpenseBreakdownView: View {
    
    @State private var isDescendingOrder = false
    @Binding var presentSideMenu: Bool
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) // Default to the current month
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    private let expenseController = ExpenseViewController()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    if let userProfile = UserManager.shared.currentUser {
                        Spacer()
                        let expensesForSelectedMonth = expenseController.expensesForSelectedMonth(userProfile: userProfile, selectedMonth: selectedMonth, selectedYear: selectedYear)
                        Text("Total Expense Amount: \(expenseController.totalExpenseAmount(expenses: expensesForSelectedMonth)) ₺")
                                        .font(.headline)
                                        .padding()
     
                        HStack {
                            Picker("Select Month", selection: $selectedMonth) {
                                ForEach(1...12, id: \.self) { month in
                                    Text(DateFormatter().monthSymbols[month - 1])
                                        .tag(month)
                                }
                            }
                            .environment(\.locale, Locale(identifier: "en_US"))
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .accentColor(.black)
                        

                            Picker("Select Year", selection: $selectedYear) {
                                ForEach(2020...2024, id: \.self) { year in
                                    Text(String(year))
                                        .tag(year)
                                        .accessibilityLabel(Text("\(year)"))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .accentColor(.black)
                            
                            
                            Spacer()
                            
                            Button(action: {
                                   isDescendingOrder = true
                               }) {
                                   Image(systemName: "arrow.up.circle.fill")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                       .foregroundColor(Color("textColor"))
                               }
                               Button(action: {
                                   isDescendingOrder = false
                               }) {
                                   Image(systemName: "arrow.down.circle.fill")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                       .foregroundColor(Color("textColor"))
                               }
                       }
                       .padding()

                        let sortedExpenses = isDescendingOrder ? expensesForSelectedMonth.sorted { $0.amount > $1.amount } : expensesForSelectedMonth.sorted { $0.amount < $1.amount }
                        
                        if sortedExpenses.isEmpty {
                            Text("No income to display yet...")
                        }

                        ForEach(sortedExpenses, id: \.transactionId) { expense in
                            Divider()
                            ExpenseRowView(expense: expense)
                                .padding()
                            
                            }
                    } else {
                        Text("No income to display yet...")
                    }
                }
            }
        }
    }

}



func expensesByParentCategory(expenses: [ExpenseModel]) -> [String: Double] {
    let groupedExpenses = Dictionary(grouping: expenses) { $0.parentCategory }
    var expensesByCategory = [String: Double]()
    
    for (category, expenses) in groupedExpenses {
        let total = expenses.reduce(0) { $0 + $1.amount }
        expensesByCategory[category] = total
    }
    
    return expensesByCategory
}


struct ExpenseRowView: View {
    var expense: ExpenseModel

    var body: some View {
        HStack {
            if let categoryDetails = getCategoryDetails(byTag: expense.category) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.icon.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: categoryDetails.systemImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(categoryDetails.color))
                        
                    }
                VStack(alignment: .leading, spacing: 4) {
                    Text(categoryDetails.name)
                        .font(.subheadline)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(Color("textColor"))
                    Text("\(formattedDate())")
                        .font(.subheadline)
                        .foregroundColor(Color("textColor"))
                }
                
                Spacer()
                
                Text(String(format: "%.2f %@", expense.amount, "₺"))
                    .font(.footnote)
                    .opacity(0.7)
                    .lineLimit(1)
                    .foregroundColor(Color("textColor"))
                //                .foregroundColor(transaction.type == TransactionType.credit.rawValue ? Color.text : .primary)
            }
        }
    }

    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: expense.date)
    }
    
    func getCategoryDetails(byTag tag: String) -> ExpenseCategory? {
        return ExpenseCategories.allCategories.first { $0.tag == tag }
    }

}


struct ExpenseBreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseBreakdownView(presentSideMenu: .constant(false))
    }
}
