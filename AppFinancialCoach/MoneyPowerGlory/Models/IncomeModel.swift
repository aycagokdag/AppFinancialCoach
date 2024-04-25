import Foundation
import FirebaseFirestore

class IncomeModel: TransactionModel {
    let isFixedIncome: Bool
    let incomeName: String
    
    init(incomeId: String, userId: String, incomeAmount: Double, incomeDate: Date, isFixedIncome: Bool, incomeName: String, oldBalance: Double, newBalance: Double) {
        self.isFixedIncome = isFixedIncome
        self.incomeName = incomeName
        super.init(transactionId: incomeId, userId: userId, amount: incomeAmount, date: incomeDate, oldBalance: oldBalance, newBalance: newBalance)
    }
    
    override init(data: [String: Any]) {
        self.isFixedIncome = data["isFixedIncome"] as? Bool ?? false
        self.incomeName = data["incomeName"] as? String ?? ""
        super.init(data: data)
    }
    
    override var dictRepresentation: [String: Any] {
        var dict = super.dictRepresentation
        dict["isFixedIncome"] = isFixedIncome
        dict["incomeName"] = incomeName
        return dict
    }
}
