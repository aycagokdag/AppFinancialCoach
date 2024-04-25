import Foundation

class HomeViewController {
    func daysLeftInMonth() -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()

        // Get the range of days in the current month
        guard let currentMonthRange = calendar.range(of: .day, in: .month, for: currentDate) else {
            return nil
        }

        // Calculate the remaining days in the month
        let totalDaysInMonth = currentMonthRange.count
        let currentDay = calendar.component(.day, from: currentDate)
        let daysLeft = totalDaysInMonth - currentDay

        return daysLeft
    }
}

