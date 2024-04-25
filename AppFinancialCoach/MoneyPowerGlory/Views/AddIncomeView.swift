import SwiftUI

struct AddIncomeView: View {
    @State private var date = Date()
    @State private var amount: String = ""
    @State private var isFixedIncome = false
    @State private var incomeName: String = ""
    @State private var showAlert = false
    @Binding var isHomePageSelected: Bool
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                Spacer()
                
                VStack {
                    HStack {
                        Text("New Income")
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
                            Text("Is Fixed Income:")
                                .font(.headline)
                                .foregroundColor(Color("textColor"))
                            Spacer()
                            Toggle(isOn: $isFixedIncome){}
                        }
                        .padding()
                        
                        HStack {
                            Text("Income Name:")
                                .font(.headline)
                                .foregroundColor(Color("textColor"))
                            Spacer()
                            TextField("Salary", text: $incomeName)
                                .multilineTextAlignment(.trailing)
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
                        let incomeId = UUID().uuidString
                        UserManager.shared.fetchUserData(userID: userID) {
                            if var userProfile = UserManager.shared.currentUser {
                                let income = IncomeModel(
                                    incomeId: incomeId,
                                    userId: userProfile.uid,
                                    incomeAmount: Double(amount) ?? 0.0,
                                    incomeDate: date,
                                    isFixedIncome: isFixedIncome,
                                    incomeName: incomeName,
                                    oldBalance: userProfile.currentBalance,
                                    newBalance: userProfile.currentBalance + (Double(amount) ?? 0.0)
                                )
                                userProfile.addIncome(income: income)
                                userProfile.currentBalance = userProfile.currentBalance + (Double(amount) ?? 0.0)
                                UserManager.shared.currentUser = userProfile
                                UserManager.shared.addIncomeData() {}
                                amount = ""
                                incomeName = ""
                                showAlert = true // Show alert
                            }
                        }
                    } label: {
                        Text("Add Income")
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
                            title: Text("Income Added"),
                            message: Text("Your income has been added."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
        }
    }
}

struct AddIncomeView_Previews: PreviewProvider {
    // Create a dummy selectedCategory variable
    static var previews: some View {
        AddIncomeView(isHomePageSelected: .constant(false))
    }
}


