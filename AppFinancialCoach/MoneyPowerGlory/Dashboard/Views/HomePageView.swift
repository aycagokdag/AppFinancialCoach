import SwiftUI

struct HomePageView: View {
    
    @Binding var presentSideMenu: Bool
    @Binding var isHomePageSelected: Bool
    @State private var navigateToStockSearch = false
    @State private var budgetCreate = false
    
    
    private let homeController = HomeViewController()
            
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
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("textColor"))
                    }
                }
                
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
                    
                    if !userProfile.plannedBudget.isEmpty {
                        let chartData = userProfile.plannedBudget.map { name, amount in
                            ExpenseData(name: name, amount: amount/5, color: colorForCategory(name))
                        }
                        
                        DonutChartView(expensesByCategory: chartData)
                            .frame(height: 360)
                            .padding()
                    } else {
                        Text("You have not planned your budget yet.")
                        Button("Create one here!"){
                            self.budgetCreate = true
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
                    if !userProfile.goals.isEmpty {
                        DashboardGoalsWidget(financialGoals: userProfile.goals)
                    }
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
