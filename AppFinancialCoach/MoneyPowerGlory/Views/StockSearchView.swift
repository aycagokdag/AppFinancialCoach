import SwiftUI

struct StockSearchView: View {
    @State private var query = ""
    @State private var searchResults: [StockSymbol] = []
    @State private var selectedStock: StockSymbol?
    @State private var amountPurchased: String = ""
    @State private var acquisitionDate = Date()
    @State private var showDetailForStock: StockSymbol?

    var body: some View {
        NavigationView {
            VStack {
                if selectedStock == nil {
                    TextField("Search...", text: $query, onCommit: {
                        searchStocks(query: query) { results in
                            self.searchResults = results
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                    List(searchResults) { stock in
                        Text("\(stock.symbol)")
                            .font(.footnote)
                            .onTapGesture {
                                self.selectedStock = stock
                            }
                    }
                } else if let selectedStock = selectedStock {
                    StockDetailView(stock: selectedStock, amountPurchased: $amountPurchased, acquisitionDate: $acquisitionDate) {
                        // Reset for a new search or after saving
                        self.selectedStock = nil
                        self.amountPurchased = ""
                        self.query = ""
                        self.searchResults = []
                    }
                }
            }
            .navigationBarTitle(selectedStock == nil ? "Search Stocks" : selectedStock!.symbol)
            
        }
    }
}
struct StockDetailView: View {
    var stock: StockSymbol
    @Binding var amountPurchased: String
    @Binding var acquisitionDate: Date
    var onSave: () -> Void
    @State private var selectedStockPrice: Double? = nil
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Stock Details")) {
                Text("Symbol: \(stock.symbol)")
                Text("Name: \(stock.name)")
                if let price = selectedStockPrice {
                    Text(String(format: "$%.2f", price))
                } else {
                    Text("Fetching price...")
                   .onAppear {
                       fetchLatestStockPrice(symbol: stock.symbol) { price in
                           self.selectedStockPrice = price
                       }
                   }
                }
                TextField("Amount Purchased", text: $amountPurchased)
                    .keyboardType(.numberPad)
                DatePicker("Acquisition Date", selection: $acquisitionDate, displayedComponents: .date)
            }
            
            // Save Button should be directly within the Form or Section, but not inside onTapGesture
            Button("Save") {
                if let quantity = Double(amountPurchased), let price = selectedStockPrice {
                    UserManager.shared.fetchUserData(userID: userID) {
                        if var userProfile = UserManager.shared.currentUser {
                            let stockSaving = StockSavingsModel(
                                id: UUID().uuidString,
                                userId: userProfile.uid,
                                quantity: quantity,
                                acquisitionDate: acquisitionDate,
                                tickerSymbol: stock.symbol
                            )
                            userProfile.addSaving(saving: stockSaving)
                            UserManager.shared.currentUser = userProfile
                            UserManager.shared.addSavingData() {
                               //
                            }
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("darkPurple"))
            )
        }
    }
}


struct StockSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StockSearchView()
    }
}
