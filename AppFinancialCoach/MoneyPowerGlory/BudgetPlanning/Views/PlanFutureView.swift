import SwiftUI
import UIKit
import Charts
import SwiftUICharts


struct ExpenseData: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var color: Color
}


struct PlanFutureView: View {
    @Binding var presentSideMenu: Bool
    @State var isFuturePredictionVisible = false
    @State var predictedExpenses: [String: Double]
    @State var savingPerMonth: Double
    @State private var totalSavings: Double = 0.0
    @State var expenses: [String: Double]
    
    let planFutureController = PlanFutureViewController()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    if let userProfile = UserManager.shared.currentUser {
                        Text("Your current expense breakdown")
                            .font(.title3)
                        HStack {
                            if !expenses.isEmpty {
                                let chartData = expenses.map { name, amount in
                                    ExpenseData(name: name, amount: amount/5, color: colorForCategory(name))
                                }
                                
                                DonutChartView(expensesByCategory: chartData)
                                    .frame(height: 360)
                                    .padding()
                                Spacer()
                            }
                        }
                        .padding()
                        VStack (alignment: .leading, spacing: 4){
                            Text("Balance: \(userProfile.currentBalance, specifier: "%.2f")")
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .font(.headline)
                                Divider()
                                Text("Total Savings: \(totalSavings, specifier: "%.2f")")
                                .onAppear {
                                    getSavingsSum(savings: userProfile.savings) { totalSum in
                                        self.totalSavings = totalSum
                                    }
                                }
                               .padding()
                               .background(Color.white.opacity(0.9))
                               .font(.headline)
                            Divider()
                   }
                   .padding(.bottom)
                            Button(action: {
                                isFuturePredictionVisible = true
                            }) {
                                Text("Plan for the next month")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("darkPurple"))
                                    )
                                    .padding(.horizontal)
                            }
                        } else {
                            Text("No income to display yet...")
                        }
                    }
                }
                .sheet(isPresented: $isFuturePredictionVisible) {
                    PredictedExpensesView(isFuturePredictionVisible: $isFuturePredictionVisible, predictedExpenses: $predictedExpenses, savingPerMonth: $savingPerMonth, expenses: $expenses)
                }
                .onAppear {
                    if let userProfile = UserManager.shared.currentUser {
                        expenses = planFutureController.getExpenseBreakdown(userProfile: userProfile)
                        planFutureController.getPlannedBreakdown(uid: userProfile.uid) { plannedExpenses, savingPerMonth in
                            if let plannedExpenses = plannedExpenses, let savingPerMonth = savingPerMonth {
                                self.predictedExpenses = plannedExpenses
                                self.savingPerMonth = savingPerMonth
                            } else {
                                print("Error occurred or response is nil")
                            }
                        }
                        getSavingsSum(savings: userProfile.savings) { totalSum in
                            self.totalSavings = totalSum
                        }
                    }
                }

                .navigationTitle("")
                .navigationBarItems(leading:
                                        Button(action: {
                    presentSideMenu.toggle()
                }) {
                    Image(systemName: "text.justify.leading")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("textColor"))
                }
                )
            }
        
    }
    func getSavingsSum(savings: [SavingsModel], completion: @escaping (Double) -> Void) {
        let dispatchGroup = DispatchGroup()
        var totalSum: Double = 0
        
        for saving in savings {
            dispatchGroup.enter()
            saving.getCurrentAmount { amount in
                DispatchQueue.main.async {
                    if let amount = amount {
                        totalSum += amount
                        print("Adding amount: \(amount)")
                    } else {
                        print("Received nil for current amount, ensure your subclasses are returning valid amounts.")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print("Total Savings Sum: \(totalSum)")
            completion(totalSum)
        }
    }


}
    


struct DonutChartView: View {
    var  expensesByCategory: [ExpenseData]
    @State private var selectedAmount: Double?
    @State private var selectedExpense: ExpenseData?

    var body: some View {
        NavigationStack {
            VStack {
                Chart(expensesByCategory) { expense in
                    SectorMark(
                        angle: .value("Amount", expense.amount),
                        innerRadius: .ratio(0.65),
                        outerRadius: selectedExpense?.name == expense.name ? 175 : 150,
                        angularInset: 1
                    )
                    .foregroundStyle(Color(expense.color))
                    .cornerRadius(10)
                    
                }
                .chartAngleSelection(value: $selectedAmount)
                .chartBackground { _ in
                    if let selectedExpense {
                        VStack {
                            Image(systemName: "creditcard.fill")
                                .font(.subheadline)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(selectedExpense.color))
                            Text(selectedExpense.name)
                                .font(.subheadline)
                            Text("Amount: \(selectedExpense.amount, specifier: "%.2f")")
                                .font(.footnote)
                        }
                    } else {
                        VStack {
                            Image(systemName: "creditcard.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("Select a segment")
                        }
                    }
                }
                .frame(height: 350)
                Spacer()
            }
            .onChange(of: selectedAmount) { oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelectedWineType(value: newValue)
                    }
                }
            }
            .padding()
        }
    }
    private func getSelectedWineType(value: Double) {
        var cumulativeTotal = 0
        let expenseType = expensesByCategory.first { expenseType in
                  cumulativeTotal += Int(expenseType.amount)
                    if Int(value) <= cumulativeTotal {
                      selectedExpense = expenseType
                      return true
                  }
                  return false
              }
       }
}


struct PredictedExpensesView: View {
    @Binding var isFuturePredictionVisible: Bool
    @Binding var predictedExpenses: [String: Double]
    @Binding var savingPerMonth: Double
    @Binding var expenses: [String: Double]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    VStack {
                       VStack {
                            if !predictedExpenses.isEmpty {
                                Text("Planned expense breakdown based on your personal data")
                                    .font(.headline)
                                    .padding()
                                Text("You need to decrease your expenses and save more in order to meet your goals!")
                                    .font(.subheadline)
                                    .padding()
                                let chartData = predictedExpenses.map { name, amount in
                                    ExpenseData(name: name, amount: amount, color: colorForCategory(name))
                                }
                                
                                DonutChartView(expensesByCategory: chartData)
                                    .frame(height: 400)
                                    .padding()
                                Spacer()
                                
                                ForEach(Array(predictedExpenses.enumerated()), id: \.element.key) { index, expense in
                                    VStack { // Wrap each iteration in a VStack or Group
                                        Divider()
                                        let normalExpenseAmount = expenses[expense.key] ?? 0
                                        ExpenseUpdatesRow(expenseName: expense.key, expenseAmount: expense.value, normalExpenseAmount: normalExpenseAmount/5)
                                            .padding()
                                    }
                                }



                                Text("Monthly savings you'll make with this plan: \(String(format: "%.2f", savingPerMonth))")
                                    .font(.subheadline)
                                    .padding()
                            }
                        }
                        
                   
                        
                    }
                    Spacer()
                    Button(action: {
                        isFuturePredictionVisible = false
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Done")
                                .bold()
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}
struct ExpenseUpdatesRow: View {
    var expenseName: String
    var expenseAmount: Double
    var normalExpenseAmount: Double
    
    private var expenseDifference: Double {
        expenseAmount - normalExpenseAmount
   }

   private var arrowImageName: String {
       expenseDifference > 0 ? "arrow.up" : "arrow.down"
   }

   private var arrowColor: Color {
       expenseDifference > 0 ? .green : .red
   }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: imageForCategory(expenseName))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colorForCategory(expenseName))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expenseName)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(.black)
                HStack {
                   Text(String(format: "%.2f", expenseDifference))
                       .font(.subheadline)
                       .foregroundColor(.black)
                   Image(systemName: arrowImageName)
                       .foregroundColor(arrowColor)
               }
            }
            
            Spacer()
            
            Text(String(format: "%.2f ₺", expenseAmount))
                .font(.footnote)
                .opacity(0.7)
                .lineLimit(1)
                .foregroundColor(.black)
        
        }
    }
}

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexString).scanHexInt64(&rgb)

        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

struct PlanFutureView_Previews: PreviewProvider {
    static var previews: some View {
        PlanFutureView(presentSideMenu: .constant(false), predictedExpenses: [:], savingPerMonth: 0, expenses: [ : ])
    }
}
