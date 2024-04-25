import Foundation

struct Question {
    let text: String
    let options: [String]
}

struct Score {
    var impulsive: Int
    var spender: Int
    var planner: Int
    var investor: Int
    var saver: Int
}

let questions = [
    Question(text: "How would you describe your investment knowledge?", options: ["Novice", "Intermediate", "Expert"]),
    Question(text: "What is your investment time horizon?", options: ["Short-term (1-3 years)", "Medium-term (3-5 years)", "Long-term (5+ years)"]),
    Question(text: "How do you feel about market fluctuations?", options: ["I'm not sure", "I prefer stable returns", "I'm comfortable with fluctuations"]),
    Question(text: "Which of the following statements make the most sense to you?", options: ["To completely avoid losses is something I am more interested in", "I am concerned about losses along with returns.", "I am willing to bear the consequences of a loss to maximize my returns."]),
    Question(text: "How much return would you expect from your investments?", options: ["Low returns with low risk", "Balanced returns and risk", "High returns with high risk"]),
    Question(text: "Over the next few years, you expect the annual income to:", options: ["Stay the same", "Grow moderately", "Grow substantially"]),
    Question(text: "How often do you set aside money for savings?", options: ["Regularly (e.g., monthly)", "Occasionally", "Rarely or never"]),
    Question(text: "When you receive extra money (like a bonus), what are you most likely to do with it?", options: ["Save it", "Spend it on something I've been wanting", "Invest it", "Plan or budget it for future expenses", "Make a spontaneous purchase"]),
    Question(text: "How would you describe your approach to investing?", options: ["I actively invest and enjoy taking calculated risks", "I invest conservatively", "I'm interested but don't know much about investing", "I prefer not to invest"]),
    Question(text: "Do you regularly create and stick to a budget?", options: ["Always", "Sometimes", "Rarely", "Never"]),
    Question(text: "What best describes your long-term financial planning?", options: ["I have clear long-term financial goals and a plan to achieve them", "I think about long-term goals but don't have a specific plan", "I focus more on present financial needs than future ones", "I rarely think about long-term financial planning"]),
    Question(text: "How often do your emotions influence your financial decisions?", options: ["Frequently", "Sometimes", "Rarely", "Never"])
]

