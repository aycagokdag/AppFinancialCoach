import SwiftUI

struct DashboardGoalsWidget: View {
    var financialGoals: [FinancialGoalModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(financialGoals, id: \.goalId) { goal in
                    GoalView(goal: goal)
                }
            }
            .padding()
        }
    }
}

struct GoalView: View {
    let goal: FinancialGoalModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text(goal.goalName)
                .font(.headline)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            Text("$\(String(format: "%.2f", goal.amountToBeSaved))")
                .font(.title2)
                .bold()
                .foregroundColor(Color.green)
            
            VStack {
                Text("Due Date:")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                Text("\(formattedDate(from: goal.dueDate))")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(width: 180, height: 200)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
