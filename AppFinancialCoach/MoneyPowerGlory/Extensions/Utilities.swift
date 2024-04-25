import Foundation
import SwiftUI

enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case Finances
    case FinancialGoals
    case Questionnaire
    case PlanFuture
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .Finances:
            return "Finances"
        case .FinancialGoals:
            return "Financial Goals"
        case .Questionnaire:
            return "Questionnaire"
        case .PlanFuture:
            return "Plan Future"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house.fill"
        case .Finances:
            return "square.and.arrow.down"
        case .FinancialGoals:
            return "house.fill"
        case .Questionnaire:
            return "questionmark.square.dashed"
        case .PlanFuture:
            return "figure.run"
        }
    }
}

extension Color {
    static let background = Color("Background")
    static let text = Color("Text")
    static let icon = Color("Icon")
    static let iconContrast = Color("IconContrast")
}



let barColors: [Color] = [
    Color(hex: "7AA2E3"),
    Color(hex: "58A399"),
    Color(hex: "FFD700"),
    Color(hex: "98FB98"),
    Color(hex: "DDA0DD"),
    Color(hex: "FFB6C1"),
    Color(hex: "FFA07A"),
    Color(hex: "FA7070"),
    Color(hex: "87CEEB"),
    Color(hex: "32CD32")
]

func colorForCategory(_ category: String) -> Color {
    switch category {
        case "Housing":
            return barColors[0]
        case "Transportation":
            return barColors[1]
        case "Food and Dining":
            return barColors[2]
        case "Health":
            return barColors[3]
        case "Entertainment":
            return barColors[4]
        case "Personal Care":
            return barColors[5]
        case "Shopping":
            return barColors[6]
        case "Debt Payments":
            return barColors[7]
        case "Education":
            return barColors[8]
        case "Savings and Investments":
            return barColors[9]
        default:
            return Color.white // Fallback color
    }
}

func imageForCategory(_ category: String) -> String {
    switch category {
        case "Housing":
            return "house.fill"
        case "Transportation":
            return "car.fill"
        case "Food and Dining":
            return "fork.knife"
        case "Health":
            return "staroflife"
        case "Entertainment":
            return "ticket"
        case "Personal Care":
            return"figure.walk"
        case "Shopping":
            return "bed.double"
        case "Debt Payments":
            return "banknote"
        case "Education":
            return "book"
        case "Savings and Investments":
            return"Savings and Investments"
        default:
            return "house.fill" 
    }
}
