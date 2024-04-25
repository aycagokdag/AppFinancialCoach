import SwiftUI

struct HomePageView: View {
    
    @Binding var presentSideMenu: Bool
    @Binding var isHomePageSelected: Bool
    
    private let homeController = HomeViewController()
    

    
    @State private var navigateToStockSearch = false // State to control navigation
            
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        presentSideMenu.toggle()
                    } label: {
                        Image(systemName: "text.justify.leading")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("textColor"))
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        isHomePageSelected.toggle()
                        // This might need adjusting depending on your navigation logic
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("textColor"))
                    }
                }
                
                // Navigation link (hidden)
                NavigationLink(destination: StockSearchView(), isActive: $navigateToStockSearch) {
                    EmptyView()
                }
                
                Spacer()
                if let userProfile = UserManager.shared.currentUser {
                    let daysLeft = max(homeController.daysLeftInMonth() ?? 1, 1)
                    let dailyLimit = userProfile.currentBalance / Double(daysLeft)
                    Text("Your daily spending limit:")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color("textColor"))
                    Text(String(format: "%.2f %@", dailyLimit, "₺"))
                }
                Spacer()
                Button("Add Savings") {
                    navigateToStockSearch = true
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
            .padding(.horizontal, 24)
            .navigationBarHidden(true) // Hide navigation bar if not desired
        }
    }
    func daysLeftInMonth() -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the range of days in the current month
        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: currentDate) else {
            return nil
        }

        // Calculate the remaining days in the month
        let totalDaysInMonth = currentMonthRange.count
        let currentDay = calendar.component(.day, from: currentDate)
        let daysLeft = totalDaysInMonth - currentDay

        return daysLeft
    }
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(presentSideMenu: .constant(false), isHomePageSelected: .constant(false))
    }
}
