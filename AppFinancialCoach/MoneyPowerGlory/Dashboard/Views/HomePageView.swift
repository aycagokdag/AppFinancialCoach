import SwiftUI

struct HomePageView: View {
    @Binding var presentSideMenu: Bool
    @Binding var isHomePageSelected: Bool
    @State private var navigateToStockSearch = false
    @State private var budgetCreate = false
    @ObservedObject var viewModel = AdviceViewModel()

    private let homeController = HomeViewController()

    var body: some View {
        NavigationView {
            ScrollView {
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
//                                .foregroundColor(Color("textColor"))
                        }
                    }
                    
                    if let userProfile = UserManager.shared.currentUser {
//                        Text("Based on your financial habits, you are a \(userProfile.clusterName).")
                        NavigationLink(destination: StockSearchView(), isActive: $navigateToStockSearch) {
                            EmptyView()
                        }
                        
                        Spacer()
                        
                        let daysLeft = max(homeController.daysLeftInMonth() ?? 1, 1)
                        let dailyLimit = userProfile.currentBalance / Double(daysLeft)
                        Text("Your daily spending limit:")
                            .font(.headline)
                            .padding()
                            .foregroundColor(Color("textColor"))
                        Text(String(format: "%.2f %@", dailyLimit, "₺"))
                        
                        if !userProfile.plannedBudget.isEmpty {
                            let chartData = userProfile.plannedBudget.map { name, amount in
                                ExpenseData(name: name, amount: amount / 5, color: colorForCategory(name))
                            }
                            DonutChartView(expensesByCategory: chartData)
                                .frame(height: 360)
                                .padding()
                        } else {
                            Divider()
                            Button("Create one here!") {
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
                            Divider()
                        }
                        
                        if let advice = viewModel.fetchAdvice(for: userProfile.clusterNo ?? 0) {
                            AdviceView(viewModel: viewModel, advice: advice)
                        }
                        
                        if !userProfile.goals.isEmpty {
                            Divider()
                            HStack {
                                Spacer()
                                Image(systemName: "trophy.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.yellow)
                                Text("Your Current Goals")
                                    .bold()
                                Image(systemName: "trophy.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color.yellow)
                                Spacer()
                            }
                            DashboardGoalsWidget(financialGoals: userProfile.goals)
                            Divider()
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
                    Button("Get Tailored Advice") {
                        if let userProfile = UserManager.shared.currentUser {
                            clusterUser(userId: userProfile.uid)
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
                .padding(.horizontal, 24)
                .navigationBarHidden(true)
                .background(Color("background"))
            }
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

struct AdviceView: View {
    @State private var selectedCategory = 0
    @ObservedObject var viewModel: AdviceViewModel
    var advice: FinancialAdvice

    var body: some View {
        VStack {
            Text("Financial Advice")
                .font(.title)
                .bold()
                .padding(.top)
            
            Picker("Category", selection: $selectedCategory) {
                VStack {
                    Image(systemName: "banknote.fill")
                }
                .tag(0)
                
                VStack {
                    Image(systemName: "chart.bar.fill")
                }
                .tag(1)
                
                VStack {
                    Image(systemName: "calendar.badge.clock")
                }
                .tag(2)
            }
            .pickerStyle(.segmented)
            .padding()

            contentForSelectedCategory()
                .padding(.horizontal)
                .padding(.top, 10)

            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }

    @ViewBuilder
    private func contentForSelectedCategory() -> some View {
        switch selectedCategory {
        case 0:
            SavingsAdviceView(category: "Savings", viewModel: viewModel, advice: advice)
        case 1:
            InvestmentsAdviceView(category: "Investments", viewModel: viewModel, advice: advice)
        case 2:
            BudgetingAdviceView(category: "Budgeting", viewModel: viewModel, advice: advice)
        default:
            EmptyView()
        }
    }
}

struct RatingView: View {
    let viewModel: AdviceViewModel
    let adviceId: Int
    let category: String
    var maxRating = 5
    @State private var rating: Int

    init(viewModel: AdviceViewModel, adviceId: Int, category: String) {
        self.viewModel = viewModel
        self.adviceId = adviceId
        self.category = category
        self._rating = State(initialValue: viewModel.getRating(for: UserManager.shared.currentUser!, adviceId: adviceId, category: category) ?? 0)
    }

    var body: some View {
        VStack {
            Text("Rate this advice")
                .font(.footnote)
            HStack {
                ForEach(1...maxRating, id: \.self) { number in
                    Image(systemName: "star.fill")
                        .foregroundColor(number <= rating ? .yellow : .gray)
                        .onTapGesture {
                            rating = number
                            if var userProfile = UserManager.shared.currentUser {
                                viewModel.rateAdvice(user: &userProfile, adviceId: adviceId, category: category, rating: rating)
                                UserManager.shared.writeRatings(userProfile: userProfile, adviceId: adviceId, category: category, rating: rating)
                            }
                        }
                }
            }
        }
    }
}

struct SavingsAdviceView: View {
    var category: String
    var viewModel: AdviceViewModel
    var advice: FinancialAdvice

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Your personalized saving advice:")
                        .padding(5)
                        .font(.headline)
                }
                
                HStack {
                    Text(advice.advice[category] ?? "No advice available.")
                        .font(.subheadline)
                        .padding(5)
                }
            }
            RatingView(viewModel: viewModel, adviceId: advice.id, category: category)
                .padding(5)
        }
    }
}

struct InvestmentsAdviceView: View {
    var category: String
    var viewModel: AdviceViewModel
    var advice: FinancialAdvice

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Your personalized investment \n advice:")
                        .padding(5)
                        .font(.headline)
                }

                HStack {
                    Text(advice.advice[category] ?? "No advice available.")
                        .padding(5)
                        .font(.subheadline)
                }
            }
            RatingView(viewModel: viewModel, adviceId: advice.id, category: category)
                .padding(5)
        }
    }
}

struct BudgetingAdviceView: View {
    var category: String
    var viewModel: AdviceViewModel
    var advice: FinancialAdvice

    var body: some View {
        VStack {
            HStack {
                Text("Your personalized budgeting \n advice:")
                    .padding(5)
                    .font(.headline)
                Spacer()
            }
                
            HStack {
                Text(advice.advice[category] ?? "No advice available.")
                    .padding(5)
                    .font(.subheadline)
            }
            RatingView(viewModel: viewModel, adviceId: advice.id, category: category)
                .padding(5)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(presentSideMenu: .constant(false), isHomePageSelected: .constant(false))
    }
}

