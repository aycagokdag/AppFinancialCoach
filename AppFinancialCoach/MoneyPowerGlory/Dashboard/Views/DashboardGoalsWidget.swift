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
        VStack{
            HStack {
               Spacer()

            Text(goal.goalName)
                .font(.headline)
            Spacer()
            
            Button(action: {
                // Edit goal logic
                print("Edit goal")
            }) {
                Image(systemName: "pencil")
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.black)
                    .padding(4)
            }
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 0.2)
            )
            
            }
            .padding(.trailing, 5)
            Text("$\(String(format: "%.2f", goal.amountToBeSaved))")
                .font(.subheadline)
                .padding(.bottom)
            Text("Due Date:")
                .font(.footnote)
            Text("\(formattedDate(from: goal.dueDate))")
                .font(.footnote)
        }
        .padding(.all, 5)
        .frame(width: 160, height: 180)
        .cornerRadius(5)
        .shadow(radius: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5)
        )

    }
    
    private func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
