import SwiftUI

struct ProfileView: View {
    @State private var userProfile: UserProfileInfoModel?
    @State private var name: String = ""
    @State private var profession: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var riskToleranceScore: Double?

    @State private var editingName = false
    @State private var editingProfession = false
    @State private var editingEmail = false
    @State private var editingAge = false
    @State private var showAlert = false
    @State private var sliderValue: Double = 0.8
    @State private var showingQuestionnaire = false


    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                if let url = userProfile?.personalInfo.profilePhotoURL {
                    URLImageView(url: url)
                } else {
                    HStack{
                        Spacer()
                        Image("profile-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color("darkPurple").opacity(0.5), lineWidth: 10)
                            )
                            .cornerRadius(50)
                            .padding()
                        Spacer()
                        Button(action: {}){
                            Image(systemName: "pencil")
                                .imageScale(.medium)
                                .foregroundColor(.gray)
                        }
                    }
                }
                if riskToleranceScore != nil {
                    VStack(alignment: .leading){
                        Text("Risk Tolerance Score")
                            .font(.subheadline)
                        GradientSlider(value: (riskToleranceScore! / 10))
                            .padding()
                        HStack {
                           Spacer()
                           Button("Take the test again") {
                               showingQuestionnaire = true
                           }
                           .foregroundColor(.accentColor)
                           .font(.footnote)
                           .frame(width: 150, height: 30)
                           .background(
                               RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.white))
                           )
                           .overlay(
                               RoundedRectangle(cornerRadius: 8)
                                   .stroke(Color.black, lineWidth: 0.5)
                           )
                           Spacer()
                       }
                    }
                } else {
                    HStack{
                        Text("Take the test to calculate your tolarance score!")
                            .font(.footnote)
                        Spacer()
                        Button("Take the test!"){
                            showingQuestionnaire = true
                        }
                            .foregroundColor(.accentColor)
                            .font(.footnote)
                            .frame(width: 150, height: 30)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                 .fill(Color(.white))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 0.5)
                            )
                    }
                }
            
            }
            Section(header: Text("User Info")) {
                editableTextField(title: "Name", value: $name, editing: $editingName)
                editableTextField(title: "Job Title", value: $profession, editing: $editingProfession)
                editableTextField(title: "Email", value: $email, editing: $editingEmail)
                editableTextField(title: "Age", value: $age, editing: $editingAge)
                
            }
            Button("Update Profile") {
                updateProfile()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Profile Updated"),
                    message: Text("Your profile is updated succesfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .sheet(isPresented: $showingQuestionnaire) {
            QuestionnaireView()
        }
        .onAppear {
            loadUserData()
        }
    }

    private func loadUserData() {
        if let currentUser = UserManager.shared.currentUser {
            userProfile = currentUser
            name = currentUser.personalInfo.name
            profession = currentUser.personalInfo.profession
            email = currentUser.personalInfo.email
            age = currentUser.personalInfo.age
            riskToleranceScore = currentUser.personalInfo.profileScore
            print("Loaded riskToleranceScore: \(String(describing: riskToleranceScore))")
        }
    }

    private func updateProfile() {
        guard var currentUser = UserManager.shared.currentUser else {
            print("No current user found")
            return
        }
        
        currentUser.personalInfo.name = name
        currentUser.personalInfo.profession = profession
        currentUser.personalInfo.email = email
        currentUser.personalInfo.age = age
        UserManager.shared.currentUser = currentUser

        UserManager.shared.updateProfileData() { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                showAlert = true
                editingName = false
                editingAge = false
                editingProfession = false
                editingEmail = false
            }
        }
        
    }

}


@ViewBuilder
private func editableTextField(title: String, value: Binding<String>, editing: Binding<Bool>) -> some View {
    ZStack(alignment: .leading) {
        Text(title)
            .foregroundColor(value.wrappedValue.isEmpty && !editing.wrappedValue ? Color(.placeholderText) : .accentColor)
            .aspectRatio(contentMode: .fit)
            .offset(y: value.wrappedValue.isEmpty && !editing.wrappedValue ? 0 : -40)
            .scaleEffect(value.wrappedValue.isEmpty && !editing.wrappedValue ? 1 : 0.8, anchor: .leading)
            .font(.headline)
            .padding(.top, 20)
            .padding(.bottom, 30)
        Spacer()
        HStack  {
            if editing.wrappedValue {
                TextField(title, text: value)
                    .font(.footnote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
            } else {
                Text(value.wrappedValue)
                    .font(.footnote)
            }
            Spacer()
            Button(action: {
                editing.wrappedValue.toggle()
            }) {
                Image(systemName: "pencil")
                    .imageScale(.medium)
                    .foregroundColor(.gray)
            }
        }
    }
    .padding(.top, 15)
    .animation(.default)
}

struct GradientSlider: View {
    var value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.green, .red]), startPoint: .leading, endPoint: .trailing))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 15, height: 15)
                    .position(x: CGFloat(value) * geometry.size.width, y: geometry.size.height / 2)
            }
        }
        .frame(height: 20)
    }
}
