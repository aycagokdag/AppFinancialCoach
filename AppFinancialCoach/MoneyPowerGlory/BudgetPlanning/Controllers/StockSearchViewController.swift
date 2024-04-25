import Foundation

let apiKey = ""

func searchStocks(query: String, completion: @escaping ([StockSymbol]) -> Void) {
    guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(query)&apikey=\(apiKey)") else {
        print("Invalid URL")
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        if let searchResults = try? JSONDecoder().decode(SearchResults.self, from: data) {
            DispatchQueue.main.async {
                completion(searchResults.bestMatches)
            }
        }
    }.resume()
}

func fetchLatestStockPrice(symbol: String, completion: @escaping (Double?) -> Void) {
    let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(symbol)&apikey=\(apiKey)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }

        if let dailyData = try? JSONDecoder().decode(StockResponse.self, from: data),
           let firstDate = dailyData.timeSeriesDaily.keys.sorted().last,
           let closePriceString = dailyData.timeSeriesDaily[firstDate]?["4. close"],
           let closePrice = Double(closePriceString) {
            DispatchQueue.main.async {
                completion(closePrice)
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }.resume()
}
