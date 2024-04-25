import Foundation

class ExpenseViewController {
    func expensesForSelectedMonth(userProfile: UserProfileInfoModel, selectedMonth: Int, selectedYear: Int) -> [ExpenseModel] {
        userProfile.expenses.filter { expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date)
            let expenseYear = Calendar.current.component(.year, from: expense.date)
            return expenseMonth == selectedMonth && expenseYear == selectedYear
        }
    }
    
    func totalExpenseAmount(expenses: [ExpenseModel]) -> String {
        let totalAmount = expenses.reduce(0) { $0 + $1.amount }
        return String(format: "%.2f", totalAmount)
    }
}
