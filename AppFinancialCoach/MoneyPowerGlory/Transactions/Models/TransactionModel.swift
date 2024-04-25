import Foundation
import FirebaseFirestore

class TransactionModel {
    let transactionId: String
    let userId: String
    let amount: Double
    let date: Date
    let oldBalance: Double
    let newBalance: Double
    
    init(transactionId: String, userId: String, amount: Double, date: Date, oldBalance: Double, newBalance: Double) {
        self.transactionId = transactionId
        self.userId = userId
        self.amount = amount
        self.date = date
        self.oldBalance = oldBalance
        self.newBalance = newBalance
    }
    
    init(data: [String: Any]) {
        self.transactionId = data["transactionId"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.amount = data["amount"] as? Double ?? 0.0
        
        if let timestamp = data["date"] as? Timestamp {
            self.date = timestamp.dateValue()
        } else {
            self.date = Date()
        }
        
        self.oldBalance = data["oldBalance"] as? Double ?? 0.0
        self.newBalance = data["newBalance"] as? Double ?? 0.0
    }
    
    var dictRepresentation: [String: Any] {
        return [
            "transactionId": transactionId,
            "userId": userId,
            "amount": amount,
            "date": Timestamp(date: date),
            "oldBalance": oldBalance,
            "newBalance": newBalance
        ]
    }
}
