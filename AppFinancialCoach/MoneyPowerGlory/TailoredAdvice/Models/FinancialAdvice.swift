import Foundation

struct FinancialAdvice: Identifiable {
    let id: Int
    let cluster: Int
    let category: String
    let advice: [String: String]
}
