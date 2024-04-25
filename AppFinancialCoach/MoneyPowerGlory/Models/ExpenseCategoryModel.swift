import Foundation
import UIKit

struct ExpenseCategory {
    let name: String
    let tag: String
    let parentCategory: String?
    let systemImageName: String
    let color: UIColor
    
}

func getCategoryDetails(byTag tag: String) -> ExpenseCategory? {
    return ExpenseCategories.allCategories.first { $0.tag == tag }
}

let parentCategories: [String] = [
    "Housing",
    "Transportation",
    "Food and Dining",
    "Health",
    "Entertainment",
    "Personal Care",
    "Shopping",
    "Debt Payments",
    "Education",
    "Savings and Investments"
]


struct ExpenseCategories {
    static let allCategories: [ExpenseCategory] = [
               ExpenseCategory(name: "Rent/Mortgage", tag: "rent", parentCategory: "Housing", systemImageName: "house.fill", color: .systemBlue),
               ExpenseCategory(name: "Utilities (Electricity, Water, Gas)", tag: "utilities", parentCategory: "Housing", systemImageName: "bolt", color: .systemBlue),
               ExpenseCategory(name: "Home Insurance", tag: "home-insurance", parentCategory: "Housing", systemImageName: "shield", color: .systemBlue),
               ExpenseCategory(name: "Property Taxes", tag: "taxes", parentCategory: "Housing", systemImageName: "building.columns", color: .systemBlue),
               ExpenseCategory(name: "Maintenance and Repairs", tag: "repairs", parentCategory: "Housing", systemImageName: "hammer.fill", color: .systemBlue),

               ExpenseCategory(name: "Vehicle Payments", tag: "car-loan", parentCategory: "Transportation", systemImageName: "car.fill", color: .systemTeal),
               ExpenseCategory(name: "Fuel", tag: "gas", parentCategory: "Transportation", systemImageName: "fuelpump.fill", color: .systemTeal),
               ExpenseCategory(name: "Maintenance", tag: "maintenance", parentCategory: "Transportation", systemImageName: "wrench", color: .systemTeal),
               ExpenseCategory(name: "Public Transportation", tag: "public-transport", parentCategory: "Transportation", systemImageName: "tram.fill", color: .systemTeal),

               ExpenseCategory(name: "Groceries", tag: "groceries", parentCategory: "Food and Dining", systemImageName: "cart.fill", color: .systemPurple),
               ExpenseCategory(name: "Restaurants/Takeout", tag: "restaurants", parentCategory: "Food and Dining", systemImageName: "fork.knife", color: .systemPurple),
               ExpenseCategory(name: "Alcohol/Bars", tag: "bars", parentCategory: "Food and Dining", systemImageName: "bag", color: .systemPurple),

               ExpenseCategory(name: "Health Insurance", tag: "health-insurance", parentCategory: "Health", systemImageName: "staroflife", color: .systemOrange),
               ExpenseCategory(name: "Medications", tag: "medications", parentCategory: "Health", systemImageName: "pills", color: .systemOrange),
               ExpenseCategory(name: "Doctor Visits", tag: "doctor-visits", parentCategory: "Health", systemImageName: "person.2", color: .systemOrange),

               ExpenseCategory(name: "Streaming Services", tag: "streaming-services", parentCategory: "Entertainment", systemImageName: "play.tv", color: .systemPink),
               ExpenseCategory(name: "Movies/Theater", tag: "movies", parentCategory: "Entertainment", systemImageName: "film", color: .systemPink),
               ExpenseCategory(name: "Concerts/Events", tag: "concerts", parentCategory: "Entertainment", systemImageName: "ticket", color: .systemPink),
               ExpenseCategory(name: "Hobbies", tag: "hobbies", parentCategory: "Entertainment", systemImageName: "paintpalette", color: .systemPink),

               ExpenseCategory(name: "Gym Memberships", tag: "gym", parentCategory: "Personal Care", systemImageName: "figure.walk", color: .brown),
               ExpenseCategory(name: "Spa/Wellness", tag: "wellness", parentCategory: "Personal Care", systemImageName: "leaf.arrow.triangle.circlepath", color: .brown),
               
               ExpenseCategory(name: "Clothing and Accessories", tag: "clothing", parentCategory: "Shopping", systemImageName: "tshirt", color: .systemMint),
               ExpenseCategory(name: "Electronics and Software", tag: "electronics", parentCategory: "Shopping", systemImageName: "desktopcomputer", color: .systemMint),
               ExpenseCategory(name: "Home Decor", tag: "home-decor", parentCategory: "Shopping", systemImageName: "bed.double", color: .systemMint),
               ExpenseCategory(name: "Beauty Products", tag: "beauty-products", parentCategory: "Shopping", systemImageName: "paintbrush.pointed", color: .systemMint),

               ExpenseCategory(name: "Credit Card Payments", tag: "credit-card", parentCategory: "Debt Payments", systemImageName: "creditcard.fill", color: .systemRed),
               ExpenseCategory(name: "Loan/Repayments", tag: "loan", parentCategory: "Debt Payments", systemImageName: "banknote", color: .systemRed),

               ExpenseCategory(name: "Tuition", tag: "tuition", parentCategory: "Education", systemImageName: "book", color: .systemYellow),
               ExpenseCategory(name: "Books/Supplies", tag: "books", parentCategory: "Education", systemImageName: "book.fill", color: .systemYellow),
               ExpenseCategory(name: "Educational Services", tag: "educational", parentCategory: "Education", systemImageName: "person.3", color: .systemYellow),

               ExpenseCategory(name: "Retirement Contributions", tag: "retirement-contr", parentCategory: "Savings and Investments", systemImageName: "arrow.right.square", color: .systemIndigo),
               ExpenseCategory(name: "Investment Contributions", tag: "invesment-contr", parentCategory: "Savings and Investments", systemImageName: "arrow.up.square.fill", color: .systemIndigo),
               ExpenseCategory(name: "Emergency Fund", tag: "emergency-fund", parentCategory: "Savings and Investments", systemImageName: "star.square", color: .systemIndigo)

    ]
}

