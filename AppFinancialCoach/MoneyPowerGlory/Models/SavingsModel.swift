
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift 

class SavingsModel: Codable {
    var id: String
    var userId: String
    var quantity: Double
    var acquisitionDate: Date
    var additionalDetails: [String: String]?

    init(id: String, userId: String, quantity: Double, acquisitionDate: Date, additionalDetails: [String: String]? = nil) {
        self.id = id
        self.userId = userId
        self.quantity = quantity
        self.acquisitionDate = acquisitionDate
        self.additionalDetails = additionalDetails
    }
    func getCurrentAmount(completion: @escaping (Double?) -> Void) {
            completion(nil)
        }
}



class StockSavingsModel: SavingsModel {
    var tickerSymbol: String
    
    init(id: String, userId: String, quantity: Double, acquisitionDate: Date, tickerSymbol: String, additionalDetails: [String: String]? = nil) {
        self.tickerSymbol = tickerSymbol
        super.init(id: id, userId: userId, quantity: quantity, acquisitionDate: acquisitionDate, additionalDetails: additionalDetails)
    }
    
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func getCurrentAmount(completion: @escaping (Double?) -> Void) {
        fetchLatestStockPrice(symbol: self.tickerSymbol) { price in
            guard let price = price else {
                completion(nil)
                return
            }
            let currentAmount = self.quantity * price
            completion(currentAmount)
        }
    }
}

class RealEstateSavingsModel: SavingsModel {
    var location: String
    var propertyType: String
    var amount: Double
    
    init(id: String, userId: String, quantity: Double, acquisitionDate: Date, location: String, propertyType: String, amount: Double, additionalDetails: [String: String]? = nil) {
        self.location = location
        self.propertyType = propertyType
        self.amount = amount
        super.init(id: id, userId: userId, quantity: 1, acquisitionDate: acquisitionDate, additionalDetails: additionalDetails)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class CommoditySavingsModel: SavingsModel {
    var commodityType: String
    
    init(id: String, userId: String, quantity: Double, acquisitionDate: Date, commodityType: String, additionalDetails: [String: String]? = nil) {
        self.commodityType = commodityType
        super.init(id: id, userId: userId, quantity: quantity, acquisitionDate: acquisitionDate, additionalDetails: additionalDetails)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

