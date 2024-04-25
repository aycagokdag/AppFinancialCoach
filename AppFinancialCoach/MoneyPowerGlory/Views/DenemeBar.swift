import SwiftUI
/*

struct ExpenseCategoryD: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

struct BarChartView: View {
    var categories: [ExpenseCategoryD]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(categories) { category in
                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(category.color)
                            .frame(width: self.getBarWidth(category: category), height: 15)
                        Spacer()
                        Text("\(category.name) - \(String(format: "%.2f", category.amount * 100))%")
                            .foregroundColor(.black)
                            .font(.footnote)                    }
                }
            }
            .padding()
        }
    }

    func getBarWidth(category: ExpenseCategoryD) -> CGFloat {
        let maxWidth = UIScreen.main.bounds.width
        let totalAmount = categories.map { $0.amount }.reduce(0, +)
        return CGFloat(category.amount / totalAmount) * maxWidth
    }
}

struct DenemeeView: View {
    let categories: [ExpenseCategoryD] = [
        ExpenseCategoryD(name: "Food", amount: 0.25, color: .red),
        ExpenseCategoryD(name: "Transport", amount: 0.15, color: .blue),
        ExpenseCategoryD(name: "Entertainment", amount: 0.1, color: .green),
        ExpenseCategoryD(name: "Utilities", amount: 0.05, color: .orange),
        ExpenseCategoryD(name: "Rent", amount: 0.2, color: .purple),
        ExpenseCategoryD(name: "Health", amount: 0.05, color: .yellow),
        ExpenseCategoryD(name: "Clothing", amount: 0.03, color: .pink),
        ExpenseCategoryD(name: "Education", amount: 0.07, color: .cyan),
        ExpenseCategoryD(name: "Savings", amount: 0.04, color: .gray),
        ExpenseCategoryD(name: "Other", amount: 0.06, color: .brown)
    ]

    var body: some View {
        VStack {
            BarChartView(categories: categories)
        }
    }
}

struct DenemeeView_Previews: PreviewProvider {
    static var previews: some View {
        DenemeeView()
    }
}
*/
