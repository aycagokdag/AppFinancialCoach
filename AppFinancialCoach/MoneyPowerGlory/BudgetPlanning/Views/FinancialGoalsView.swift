import SwiftUI

struct FinancialGoalsView: View {
    @Binding var presentSideMenu: Bool
    @State private var isAddingGoal = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Financial Goals")
                        .font(.title)
                        .bold()
                        .padding()
                        
                        if let userProfile = UserManager.shared.currentUser {
                            ForEach(userProfile.goals, id: \.goalId) { goal in
                                GoalRowView(goal: goal)
                            }
                            
                            Button(action: {
                                isAddingGoal = true
                            }) {
                                Text("Add New Goal")
                                    .foregroundColor(.white)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("darkPurple"))
                                    )
                                    .padding(.horizontal)
                                    .sheet(isPresented: $isAddingGoal) {
                                        GoalAddView(isAddingGoal: $isAddingGoal)
                                    }
                                    .padding()
                            }
                        } else {
                            Text("No income to display yet...")
                        }
                    }
                    .padding()
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
}
    
struct GoalAddView: View {
    @Binding var isAddingGoal: Bool
    @State private var goalName = ""
    @State private var amountNeeded = ""
    @State private var goalDate = Date()
    @AppStorage("uid") var userID: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Goal Details")) {
                        TextField("Goal Name", text: $goalName)
                        TextField("Amount Needed", text: $amountNeeded)
                            .keyboardType(.decimalPad)
                        DatePicker("Goal Date", selection: $goalDate, displayedComponents: .date)
                    }
                }
                .navigationTitle("Add New Goal")
                .navigationBarItems(trailing:
                    Button("Save") {
                        let goalId = UUID().uuidString
                        UserManager.shared.fetchUserData(userID: userID) {
                            if var userProfile = UserManager.shared.currentUser {
                                let goal = FinancialGoalModel(
                                    goalId: goalId, goalName: goalName, amountToBeSaved: Double(amountNeeded) ?? 0.0, dueDate: goalDate
                                )
                                userProfile.addGoal(goal: goal)
                                UserManager.shared.currentUser = userProfile
                                UserManager.shared.addFinancialGoalData(){}
                                isAddingGoal = false
                            }
                        }
                    }
                )
            }
        }
    }
}


struct GoalRowView: View {
    var goal: FinancialGoalModel

    var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.goalName)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(String(format: "Amount needed: %.2f ₺", goal.amountToBeSaved))
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Goal date: \(goal.dueDate, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }

        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
}

struct FinancialGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialGoalsView(presentSideMenu: .constant(false))
    }
}

