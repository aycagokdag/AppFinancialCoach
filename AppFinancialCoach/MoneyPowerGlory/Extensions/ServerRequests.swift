import Foundation
import SwiftUI


func checkAnomalies(userId: String, expense: ExpenseModel, showAnomalyDialog: Binding<Bool>, expenseToAdd: Binding<ExpenseModel?>, addExpense: @escaping (ExpenseModel) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/check_anomalies") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody = CheckAnomalyRequestModel(userId: userId, expenseAmount: expense.amount, expenseCategory: expense.parentCategory)
    
    do {
        let requestBodyData = try JSONEncoder().encode(requestBody)
        request.httpBody = requestBodyData
    } catch {
        print("Error encoding request body: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making request: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Unexpected response status code")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode([String: Bool].self, from: data)
                    if let isAnomaly = response["isAnomaly"] {
                        print("Anomaly detected: \(isAnomaly)")
                        if isAnomaly {
                            showAnomalyDialog.wrappedValue = true // Show dialog if anomaly is detected
                            expenseToAdd.wrappedValue = expense // Hold the expense to add later
                        } else {
                            addExpense(expense) // Add expense directly if no anomaly
                        }
                    } else {
                        print("Unexpected response format")
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            }
    task.resume()
}


func futurePlanning(userId: String, completion: @escaping (FuturePlanningResponse?) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/future_planning") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody = CommonRequestModel(userId: userId)
    
    do {
        let requestBodyData = try JSONEncoder().encode(requestBody)
        request.httpBody = requestBodyData
    } catch {
        print("Error encoding request body: \(error)")
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error making request: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Unexpected response status code")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
           let response = try JSONDecoder().decode(FuturePlanningResponse.self, from: data)
           completion(response)
       } catch {
           print("Error decoding response: \(error)")
           completion(nil)
       }
    }
    
    task.resume()
}
