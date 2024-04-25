import Foundation

class PlanFutureViewController {
    func getExpenseBreakdown(userProfile: UserProfileInfoModel) -> [String: Double] {
      
        var categorizedExpenses: [String: [String: [ExpenseModel]]] = [:]

        for expense in userProfile.expenses {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let monthYearString = dateFormatter.string(from: expense.date)
            
            if categorizedExpenses[monthYearString] == nil {
                categorizedExpenses[monthYearString] = [:]
            }
            
            if categorizedExpenses[monthYearString]?[expense.parentCategory] == nil {
                categorizedExpenses[monthYearString]?[expense.parentCategory] = []
            }
            
            categorizedExpenses[monthYearString]?[expense.parentCategory]?.append(expense)
        }

        var monthlySpendingByCategory: [String: [String: Double]] = [:]

        for (monthYear, expensesByCategory) in categorizedExpenses {
            if monthlySpendingByCategory[monthYear] == nil {
                monthlySpendingByCategory[monthYear] = [:]
            }
            
            for (parentCategory, expenses) in expensesByCategory {
                let totalSpending = expenses.reduce(0) { $0 + $1.amount }
                monthlySpendingByCategory[monthYear]?[parentCategory] = totalSpending
            }
        }
        
        var totalSpendingByCategory: [String: Double] = [:]

        for (_, spendingByCategory) in monthlySpendingByCategory {
            // Iterate over each category in a specific month
            for (category, spending) in spendingByCategory {
                // Accumulate spending for each category
                if totalSpendingByCategory[category] == nil {
                    totalSpendingByCategory[category] = 0.0
                }
                totalSpendingByCategory[category]! += spending
            }
        }

        return totalSpendingByCategory
    }
    
    func getPlannedBreakdown(uid: String, completion: @escaping ([String: Double]?, Double?) -> Void) {
        futurePlanning(userId: uid) { response in
            if let response = response {
                completion(response.plannedExpenses, response.savingPerMonth)
            } else {
                completion(nil, nil)
            }
        }
    }

    
}

