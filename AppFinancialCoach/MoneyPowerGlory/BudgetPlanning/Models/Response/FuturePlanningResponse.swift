import Foundation

struct FuturePlanningResponse: Decodable {
    let plannedExpenses: [String: Double]
    let savingPerMonth: Double
}
