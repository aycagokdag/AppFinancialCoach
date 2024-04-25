import Foundation

struct CheckAnomalyRequestModel: Codable {
    let userId: String
    let expenseAmount: Double
    let expenseCategory: String
}
