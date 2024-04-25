import Foundation

class QuestionnaireViewController {
    
    var userScore = Score(impulsive: 0, spender: 0, planner: 0, investor: 0, saver: 0)

    
    func calculateScore(for choice: String, questionIndex: Int) {
        switch questionIndex {
        case 0: // Investment Knowledge
            if choice == "Novice" {
                userScore.impulsive += 2
                userScore.spender += 2
            } else if choice == "Intermediate" {
                userScore.planner += 3
            } else if choice == "Expert" {
                userScore.investor += 3
                userScore.saver += 1
            }
        case 1: // Investment Time Horizon
            if choice == "Short-term (1-3 years)" {
                userScore.spender += 3
                userScore.impulsive += 3
            } else if choice == "Medium-term (3-5 years)" {
                userScore.planner += 3
            } else if choice == "Long-term (5+ years)" {
                userScore.investor += 3
                userScore.saver += 3
            }
        case 2: // Market Fluctuations
            if choice == "I'm not sure" {
                userScore.impulsive += 2
                userScore.spender += 2
            } else if choice == "I prefer stable returns" {
                userScore.saver += 3
            } else if choice == "I'm comfortable with fluctuations" {
                userScore.investor += 3
                userScore.planner += 2
            }
        case 3: // Statements About Losses and Returns
            if choice == "To completely avoid losses is something I am more interested in" {
                userScore.saver += 3
            } else if choice == "I am concerned about losses along with returns." {
                userScore.planner += 2
            } else if choice == "I am willing to bear the consequences of a loss to maximize my returns." {
                userScore.investor += 3
                userScore.spender += 2
            }
        case 4: // Expected Returns from Investments
            if choice == "Low returns with low risk" {
                userScore.saver += 3
            } else if choice == "Balanced returns and risk" {
                userScore.planner += 3
            } else if choice == "High returns with high risk" {
                userScore.investor += 3
                userScore.spender += 2
            }
        case 5: // Expectations for Annual Income Growth
            if choice == "Stay the same" {
                userScore.saver += 3
            } else if choice == "Grow moderately" {
                userScore.planner += 3
            } else if choice == "Grow substantially" {
                userScore.investor += 3
                userScore.spender += 2
            }
            
        case 6: // Saving Habits
            switch choice {
            case "Regularly":
                userScore.saver += 5
                userScore.planner += 5
            case "Occasionally":
                userScore.planner += 3
            case "Rarely or never":
                userScore.spender += 5
                userScore.impulsive += 5
            default:
                break
            }

        case 7: // Spending Preferences
            switch choice {
            case "Save it":
                userScore.saver += 5
            case "Spend it on something I've been wanting":
                userScore.spender += 5
            case "Invest it":
                userScore.investor += 5
            case "Plan or budget it for future expenses":
                userScore.planner += 5
            case "Make a spontaneous purchase":
                userScore.impulsive += 5
            default:
                break
            }

        case 8: // Investment Inclination
            switch choice {
            case "Actively invest and enjoy taking calculated risks":
                userScore.investor += 5
            case "Invest conservatively":
                userScore.investor += 3
                userScore.planner += 2
            case "Interested but don’t know much":
                userScore.investor += 2
            case "Prefer not to invest":
                userScore.saver += 5
            default:
                break
            }

        case 9: // Budgeting Behavior
            switch choice {
            case "Always":
                userScore.planner += 5
            case "Sometimes":
                userScore.planner += 3
            case "Rarely":
                userScore.spender += 4
            case "Never":
                userScore.impulsive += 5
            default:
                break
            }

        case 10: // Financial Planning
            switch choice {
            case "I have clear long-term financial goals and a plan to achieve them":
                userScore.planner += 5
            case "I think about long-term goals but don't have a specific plan":
                userScore.planner += 3
                userScore.investor += 2
            case "I focus more on present financial needs than future ones":
                userScore.spender += 4
            case "I rarely think about long-term financial planning":
                userScore.impulsive += 5
            default:
                break
            }

        case 11: // Emotional Influence
            switch choice {
            case "Frequently":
                userScore.impulsive += 5
            case "Sometimes":
                userScore.spender += 3
            case "Rarely":
                userScore.planner += 2
            case "Never":
                userScore.investor += 5
                userScore.saver += 5
            default:
                break
            }

        default:
            break
        }
    }


    func goToNextQuestion(currentQuestionIndex: inout Int, questionsCount: Int, showScore: inout Bool) {
        if currentQuestionIndex < questionsCount - 1 {
            currentQuestionIndex += 1
        } else {
            showScore = true
        }
    }
}
