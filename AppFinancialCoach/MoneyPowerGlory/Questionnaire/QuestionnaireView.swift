import SwiftUI


struct QuestionnaireView: View {
    @State private var currentQuestionIndex = 0
    @State private var userScore = Score(impulsive: 0, spender: 0, planner: 0, investor: 0, saver: 0)
    @State private var showScore = false
    @State private var selectedOption: String?
    
    private let controller = QuestionnaireViewController()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if showScore {
                   scoreView
                    
                    Button("Save the Results") {
                        updateUserScore(riskTolerance: Double(userScore.investor) / 50.0 * 10.0)
                    }
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("darkPurple"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
                   
                   Button("Take the Test Again") {
                       resetTest()
                   }
                   .bold()
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color("darkPurple"))
                   .foregroundColor(.white)
                   .cornerRadius(10)
                   .padding(.top, 20)
                } else {
                    questionSection
                }
           }
           .padding()
           .frame(maxWidth: .infinity, alignment: .leading)
       }
    }
    
    private var scoreView: some View {
          VStack(alignment: .leading, spacing: 10) {
              Text("Your Score:")
                  .font(.title)
                  .bold()
              Text("Impulsive: \(userScore.impulsive)")
              Text("Spender: \(userScore.spender)")
              Text("Planner: \(userScore.planner)")
              Text("Investor: \(userScore.investor)")
              Text("Saver: \(userScore.saver)")
              let riskTolerance = Double(userScore.investor) / 50.0 * 10.0
              Text("Risk Tolerance: \(Int(riskTolerance)) / 10")
          }
      }
   
    private func updateUserScore(riskTolerance: Double) {
          guard var currentUser = UserManager.shared.currentUser else {
              print("No current user found")
              return
          }
          currentUser.personalInfo.profileScore = riskTolerance
          UserManager.shared.currentUser = currentUser
          UserManager.shared.updateProfileData() { error in
              if let error = error {
                  print("Failed to update profile data: \(error.localizedDescription)")
              } else {
                  print("Profile data updated with new risk tolerance score.")
              }
          }
      }

    private var questionSection: some View {
        Group {
            Spacer()
            Text(questions[currentQuestionIndex].text)
                .font(.title2)
                .padding(.bottom, 10)

            ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
               Button(action: {
                   self.selectedOption = option
                   self.answerChosen(option)
               }) {
                   HStack {
                       Text(option)
                           .padding()
                           .font(.subheadline)
                       Spacer()
                   }
                   .frame(maxWidth: .infinity)
                   .background(self.selectedOption == option ? Color("darkPink") : Color(.white))
                   .foregroundColor(.black)
                   .overlay(
                       RoundedRectangle(cornerRadius: 1)
                           .stroke(Color.black, lineWidth: 0.5)
                   )
               }
           }
            Spacer()
            Button(action: {
               self.goToNextQuestion()
           }) {
               Text("Next")
                   .bold()
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Color("darkPurple"))
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
           .disabled(currentQuestionIndex >= questions.count)
       }
    }

    private func answerChosen(_ choice: String) {
        controller.calculateScore(for: choice, questionIndex: currentQuestionIndex)
        userScore = controller.userScore // Update the score
    }

    private func goToNextQuestion() {
       controller.goToNextQuestion(currentQuestionIndex: &currentQuestionIndex, questionsCount: questions.count, showScore: &showScore)
   }
   
    private func resetTest() {
        currentQuestionIndex = 0
        userScore = Score(impulsive: 0, spender: 0, planner: 0, investor: 0, saver: 0)
        showScore = false
        selectedOption = nil
    }
}
