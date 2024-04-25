import SwiftUI

struct ExpenseCategoryDeneme {
    let name: String
    let amount: Double
    let color: Color
}

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct PieChartView: View {
    var categories: [ExpenseCategoryDeneme]
    let chartSize: CGFloat = 250

    var body: some View {
        ScrollView {
            Color.white.edgesIgnoringSafeArea(.all)
            HStack {
                ZStack {
                    ForEach(0..<categories.count) { index in
                        PieSlice(startAngle: .degrees(getStartAngle(index: index)),
                                 endAngle: .degrees(getEndAngle(index: index)))
                            .fill(categories[index].color)
                    }
                }
                .frame(width: chartSize, height: chartSize)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(categories.indices, id: \.self) { index in
                        HStack {
                            Rectangle()
                                .fill(categories[index].color)
                                .frame(width: 5, height: 5)
                            Text(categories[index].name)
                                .foregroundColor(categories[index].color)
                                .font(.footnote)
                        }
                    }
                }
            }
        }
    }
    
    func getStartAngle(index: Int) -> Double {
         let totalAmount = categories.reduce(0) { $0 + $1.amount }
         if index == 0 {
             return 0
         } else {
             let previousCategoriesAmount = categories[0..<index].reduce(0) { $0 + $1.amount }
             let previousCategoryEndAngle = previousCategoriesAmount / totalAmount * 360
             return previousCategoryEndAngle
         }
     }

     func getEndAngle(index: Int) -> Double {
         let totalAmount = categories.reduce(0) { $0 + $1.amount }
         let startAngle = getStartAngle(index: index)
         
         let endAngle = startAngle + categories[index].amount / totalAmount * 360
         return endAngle
     }
}

struct DenemeView: View {
    let categories: [ExpenseCategoryDeneme] = [
        ExpenseCategoryDeneme(name: "Food", amount: 0.25, color: .red),
        ExpenseCategoryDeneme(name: "Transport", amount: 0.15, color: .blue),
        ExpenseCategoryDeneme(name: "Entertainment", amount: 0.1, color: .green),
        ExpenseCategoryDeneme(name: "Utilities", amount: 0.05, color: .orange),
        ExpenseCategoryDeneme(name: "Rent", amount: 0.2, color: .purple),
        ExpenseCategoryDeneme(name: "Health", amount: 0.05, color: .yellow),
        ExpenseCategoryDeneme(name: "Clothing", amount: 0.03, color: .pink),
        ExpenseCategoryDeneme(name: "Education", amount: 0.07, color: .cyan),
        ExpenseCategoryDeneme(name: "Savings", amount: 0.04, color: .gray),
        ExpenseCategoryDeneme(name: "Other", amount: 0.06, color: .brown)
    ]

    var body: some View {
            VStack {
                PieChartView(categories: categories)
                    .padding()
            }
    }
}

struct DenemeView_Previews: PreviewProvider {
    static var previews: some View {
        DenemeView()
    }
}
