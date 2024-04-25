import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import UIKit

final class UserManager {
    
    @AppStorage("uid") var userID: String = ""
    static let shared = UserManager()
    @Published var currentUser: UserProfileInfoModel?
    private init() {}
    
    
    /**
     Called after sign in.
     Creates new user and writes it into database
     */
    func createNewUser(user: UserProfileInfoModel){
        var userData: [String:Any] = [
            "user_id": user.uid,
            "date_created": user.date_created
        ]
        userData["email"] = user.personalInfo.email
        Firestore.firestore().collection("users").document(user.uid).setData(userData, merge: false)
        
        UserManager.shared.currentUser = UserProfileInfoModel(uid: user.uid, email: user.personalInfo.email)
    
    }
    
    
    /**
     Called after login
     Fetches user's existing data from database.
     */
    func fetchUserData(userID: String, completion: @escaping () -> Void) {
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("document is found")
                let userData = document.data()
                if let email = userData?["email"] as? String,
                   let dateCreatedTimestamp = userData?["date_created"] as? Timestamp {
                    
                    let dateCreated = dateCreatedTimestamp.dateValue()
                    let currentBalance = userData?["currentBalance"] as? Double ?? 0.0
                    
                    // Initialize UserProfileInfoModel with the retrieved data
                    var userProfile = UserProfileInfoModel(
                        uid: userID,
                        personalInfo: PersonalInfoModel(email: email),
                        date_created: dateCreated,
                        currentBalance: currentBalance,
                        expenses: [],
                        incomes: [],
                        savings: [],
                        goals: []
                    )
                    
                    if let expensesData = userData?["expenses"] as? [[String: Any]] {
                        let expenses = expensesData.map { ExpenseModel(data: $0) }
                        userProfile.expenses = expenses
                    }
                    
                    // Fetch incomes if they exist in the user data
                    if let incomesData = userData?["incomes"] as? [[String: Any]] {
                        let incomes = incomesData.map { IncomeModel(data: $0) }
                        userProfile.incomes = incomes
                    }
                    
                    if let goalsData = userData?["goals"] as? [[String: Any]] {
                        let goals = goalsData.map { FinancialGoalModel(data: $0) }
                        userProfile.goals = goals
                    }
                    

                    UserManager.shared.currentUser = userProfile

                    completion()
                } else {
                    print("Error parsing user data from Firestore")
                    completion()
                }
            } else {
                print("User document not found in Firestore")
                completion()
            }
        }
    }
    
    
    /**
     Called after add expense method.
     Adds new expense information to the database.
     */

    func addExpenseData(completion: @escaping () -> Void) {
        print("addition of expense data is started")
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
                let updatedFields: [String: Any] = [
                    "expenses": userProfile.expenses.map { $0.dictRepresentation },
                    "currentBalance": userProfile.currentBalance
                ]
                //print(userProfile.expenses.map { $0.expenseModelDictRepresentation })
                // Update the user's document in Firestore
                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully.")
                    }
                    completion()
                }
        }
    }
    
    
    func addIncomeData(completion: @escaping () -> Void) {
        print("Addition of income data is started")
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
            UserManager.shared.fetchUserData(userID: userID) {
                let updatedFields: [String: Any] = [
                    "incomes": userProfile.incomes.map { $0.dictRepresentation },
                    "currentBalance": userProfile.currentBalance
                ]
                print(userProfile.incomes.map { $0.dictRepresentation }) // Make sure this works

                // Update the user's document in Firestore
                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully.")
                    }
                    completion()
                }
            }
        }
    }
    
    
    func addFinancialGoalData(completion: @escaping () -> Void) {
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
            UserManager.shared.fetchUserData(userID: userID) {
                let updatedFields: [String: Any] = [
                    "goals": userProfile.goals.map { $0.dictRepresentation },
                ]
                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully.")
                    }
                    completion()
                }
            }
        }
    }
    
    func updateProfileData(completion: @escaping (Error?) -> Void) {
        guard let userProfile = UserManager.shared.currentUser else {
            completion(NSError(domain: "UserProfileError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user profile is nil"]))
            return
        }

        let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)

        let updatedFields: [String: Any] = [
            "personalInfo.name": userProfile.personalInfo.name,
            "personalInfo.profession": userProfile.personalInfo.profession,
            "personalInfo.email": userProfile.personalInfo.email
        ]

        userDocumentRef.updateData(updatedFields) { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
                completion(error)
            } else {
                print("User document updated successfully.")
                completion(nil)
            }
        }
    }

    func addSavingData(completion: @escaping () -> Void) {
        print("Addition of saving data is started")
        if let userProfile = UserManager.shared.currentUser {
            let userDocumentRef = Firestore.firestore().collection("users").document(userProfile.uid)
            UserManager.shared.fetchUserData(userID: userProfile.uid) {
                // Mapping each saving to its dictionary representation
                let savingsDicts = userProfile.savings.map { saving -> [String: Any]? in
                    var dict: [String: Any] = [
                        "id": saving.id,
                        "userId": saving.userId,
                        "quantity": saving.quantity,
                        "acquisitionDate": Timestamp(date: saving.acquisitionDate),
                    ]
                    if let additionalDetails = saving.additionalDetails {
                        dict["additionalDetails"] = additionalDetails
                    }

                    // Handling specific types
                    if let stockSaving = saving as? StockSavingsModel {
                        dict["type"] = "StockSavingsModel"
                        dict["tickerSymbol"] = stockSaving.tickerSymbol
                    } else if let realEstateSaving = saving as? RealEstateSavingsModel {
                        dict["type"] = "RealEstateSavingsModel"
                        dict["location"] = realEstateSaving.location
                        dict["propertyType"] = realEstateSaving.propertyType
                        dict["amount"] = realEstateSaving.amount
                    } else if let commoditySaving = saving as? CommoditySavingsModel {
                        dict["type"] = "CommoditySavingsModel"
                        dict["commodityType"] = commoditySaving.commodityType
                    }

                    return dict
                }.compactMap { $0 }
                
                let updatedFields: [String: Any] = ["savings": savingsDicts]

                userDocumentRef.setData(updatedFields, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully with savings data.")
                    }
                    completion()
                }
            }
        }
    }



}


