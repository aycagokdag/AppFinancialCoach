import Foundation
import FirebaseFirestore

class ExpenseModel: TransactionModel {
    let category: String
    let parentCategory: String
    let riskProfileScore: Double
    
    init(expenseId: String, userId: String, expenseAmount: Double, expenseDate: Date, category: String, parentCategory: String, oldBalance: Double, newBalance: Double, riskProfileScore: Double = 0.0) {
        self.category = category
        self.parentCategory = parentCategory
        self.riskProfileScore = riskProfileScore
        super.init(transactionId: expenseId, userId: userId, amount: expenseAmount, date: expenseDate, oldBalance: oldBalance, newBalance: newBalance)
    }
    
    override init(data: [String: Any]) {
        self.category = data["category"] as? String ?? ""
        self.parentCategory = data["parentCategory"] as? String ?? ""
        self.riskProfileScore = data["riskProfileScore"] as? Double ?? 0.0
        super.init(data: data)
    }
    
    override var dictRepresentation: [String: Any] {
        var dict = super.dictRepresentation
        dict["category"] = category
        dict["parentCategory"] = parentCategory
        dict["riskProfileScore"] = riskProfileScore
        return dict
    }
}
