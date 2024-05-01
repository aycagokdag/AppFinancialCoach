import SwiftUI

struct DashboardGoalsWidget: View {
    var financialGoals:  [FinancialGoalModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
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
        VStack(alignment: .leading){
            Text(goal.goalName)
                .font(.headline)
            Text("$\(String(format: "%.2f", goal.amountToBeSaved))")
                .font(.subheadline)
                .padding(.bottom)
            Text("Due Date:")
                .font(.footnote)
            Text("\(formattedDate(from: goal.dueDate))")
                .font(.footnote)
        }
        .frame(width: 160, height: 130)
        .padding(.bottom)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
        .shadow(radius: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 0.5)
        )

    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
