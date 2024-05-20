import SwiftUI
import UIKit


struct AddExpenseView: View {
    @State private var date = Date()
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var receiptPhoto: Image? = nil
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showAlert = false
    @Binding var isHomePageSelected: Bool
    @AppStorage("uid") var userID: String = ""
    @EnvironmentObject var viewModel: ViewModel
    @State private var showingCategorySelection = false
    @State private var showAnomalyDialog = false
    @State private var expenseToAdd: ExpenseModel?
    @State private var showAnomalyDetail = false

    
    
    
    var body: some View {
        NavigationView {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Spacer()
                    VStack {
                        HStack {
                            Text("New Expense")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Color("textColor"))
                            
                        }
                        .padding()
                        .padding(.top)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Date:")
                                    .font(.headline)
                                    .foregroundColor(Color("textColor"))
                                Spacer()
                                DatePicker("Date", selection: $date, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding()
                            
                            HStack {
                                Text("Amount:")
                                    .font(.headline)
                                    .foregroundColor(Color("textColor"))
                                Spacer()
                                TextField("111.5", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                Image(systemName: "turkishlirasign")
                                    .foregroundColor(Color("textColor"))
                            }
                            .padding()
                            
                            HStack {
                                Text("Category:")
                                    .font(.headline)
                                Spacer()
                                //TextField("Groceries", text: $category)
                                    .multilineTextAlignment(.trailing)
                                VStack {
                                    Button(action: {
                                        viewModel.isCategorySelection = true
                                    }) {
                                        VStack {
                                            Image(systemName: viewModel.selectedCategory?.systemImageName ?? "house.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(Color(viewModel.selectedCategory?.color ?? .systemBlue))
                                            Text(viewModel.selectedCategory?.name ?? "Select Category")
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.center)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.white))
                        )
                        .padding()
                        
                        Spacer()
                        Spacer()
                        
                        Button {
                            let expenseId = UUID().uuidString
                            UserManager.shared.fetchUserData(userID: userID) {
                                if let userProfile = UserManager.shared.currentUser {
                                    let expense = ExpenseModel(
                                        expenseId: expenseId,
                                        userId: userProfile.uid,
                                        expenseAmount: Double(amount) ?? 0.0,
                                        expenseDate: date,
                                        category: viewModel.selectedCategory?.tag ?? "rent",
                                        parentCategory: viewModel.selectedCategory?.parentCategory ?? "Housing",
                                        oldBalance: userProfile.currentBalance,
                                        newBalance: userProfile.currentBalance - (Double(amount) ?? 0.0)
                                    )
                                    checkAnomalies(userId: userID, expense: expense, showAnomalyDialog: $showAnomalyDialog, expenseToAdd: $expenseToAdd, addExpense: addExpense)
                                }
                            }
                        } label: {
                            Text("Add Expense")
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
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Expense Added"),
                                message: Text("Your expense has been added."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }
                .fullScreenCover(isPresented: $viewModel.isCategorySelection) {
                    ExpenseCategoriesView(showingCategorySelection: $viewModel.isCategorySelection)
                        .environmentObject(viewModel)
                }
            }
        .fullScreenCover(isPresented: $showAnomalyDetail) {
            if let expense = expenseToAdd {
                AnomalyDetailView(expense: expense)
            }
        }
        .confirmationDialog("Anomaly Detected: This expense is unusually high compared to your typical spendings. Would you like to review its impact on your budget?", isPresented: $showAnomalyDialog, actions: {
                        Button("No") {
                            showAnomalyDetail = true
                            showAnomalyDialog = false
                            amount = ""
                            viewModel.selectedCategory = nil
                        }
                        
                        Button("Yes") {
                            if let expense = expenseToAdd {
                                addExpense(expense: expense)
                            }
                        }
                    })
        }
    
    private func addExpense(expense: ExpenseModel) {
         UserManager.shared.fetchUserData(userID: userID) { [self] in
             if var userProfile = UserManager.shared.currentUser {
                 userProfile.addExpense(expense: expense)
                 userProfile.currentBalance -= expense.amount
                 UserManager.shared.currentUser = userProfile
                 UserManager.shared.addExpenseData() {
                     amount = ""
                     viewModel.selectedCategory = nil
                     showAlert = true
                 }
             }
         }
     }
}


struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModel()
        AddExpenseView(isHomePageSelected: .constant(false)).environmentObject(viewModel)
    }
}

class ViewModel: ObservableObject {
    @Published var isCategorySelection = false
    @Published var selectedCategory: ExpenseCategory?
}

