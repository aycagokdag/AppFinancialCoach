import Foundation

struct StockResponse: Codable {
    let timeSeriesDaily: [String: [String: String]]
    
    enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

