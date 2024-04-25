import SwiftUI


struct QuestionnaireView: View {
    @State private var currentQuestionIndex = 0
    @State private var userScore = Score(impulsive: 0, spender: 0, planner: 0, investor: 0, saver: 0)
    @State private var showScore = false
    @State private var selectedOption: String?
    @Binding var presentSideMenu: Bool
    
    private let controller = QuestionnaireViewController()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if showScore {
                    VStack(alignment: .leading, spacing: 10) {
                       Text("Your Score:")
                           .font(.title)
                           .bold()
                       Text("Impulsive: \(userScore.impulsive)")
                       Text("Spender: \(userScore.spender)")
                       Text("Planner: \(userScore.planner)")
                       Text("Investor: \(userScore.investor)")
                       Text("Saver: \(userScore.saver)")
                   }
                   .frame(maxWidth: .infinity, alignment: .leading)
                   .padding()
                   .background(Color("darkPurple"))
                   .foregroundColor(Color.white)
                   .cornerRadius(10)
                   
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
           .navigationBarItems(leading:
               Button(action: {
                   presentSideMenu.toggle()
               }) {
                   Image(systemName: "text.justify.leading")
                       .resizable()
                       .frame(width: 20, height: 20)
                       .foregroundColor(Color("textColor"))
               }
           )
       }
    }

    private var questionSection: some View {
        Group {
            Text(questions[currentQuestionIndex].text)
                .font(.title2)
                .bold()
                .padding(.bottom, 10)

            ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
               Button(action: {
                   self.selectedOption = option
                   self.answerChosen(option)
               }) {
                   HStack {
                       Text(option)
                           .padding()
                       Spacer()
                   }
                   .frame(maxWidth: .infinity)
                   .background(self.selectedOption == option ? Color("darkPink") : Color("darkPurple"))
                   .foregroundColor(.white)
                   .cornerRadius(10)
               }
           }

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

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView(presentSideMenu: .constant(false))
    }
}
