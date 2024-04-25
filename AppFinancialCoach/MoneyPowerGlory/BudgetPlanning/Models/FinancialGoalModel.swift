import Foundation
import FirebaseFirestore

class FinancialGoalModel {
    let goalId: String
    let goalName: String
    let amountToBeSaved: Double
    let dueDate: Date

    
    init(goalId: String, goalName: String, amountToBeSaved: Double, dueDate: Date) {
        self.goalId = goalId
        self.goalName = goalName
        self.amountToBeSaved = amountToBeSaved
        self.dueDate = dueDate
    }
    
    init(data: [String: Any]) {
        self.goalId = data["goalId"] as? String ?? ""
        self.goalName = data["goalName"] as? String ?? ""
        self.amountToBeSaved = data["amountToBeSaved"] as? Double ?? 0.0
        
        if let timestamp = data["dueDate"] as? Timestamp {
            self.dueDate = timestamp.dateValue()
        } else {
            self.dueDate = Date()
        }
    }
    
    var dictRepresentation: [String: Any] {
        return [
            "goalId": goalId,
            "goalName": goalName,
            "amountToBeSaved": amountToBeSaved,
            "dueDate": Timestamp(date: dueDate)
        ]
    }
}
