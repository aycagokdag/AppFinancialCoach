import SwiftUI

struct ProfileView: View {
    @State private var userProfile: UserProfileInfoModel?
    @State private var name: String = ""
    @State private var profession: String = ""
    @State private var email: String = ""

    @State private var editingName = false
    @State private var editingProfession = false
    @State private var editingEmail = false

    var body: some View {
        Form {
            Section(header: Text("Profile Photo")) {
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
                        Spacer()
                    }
                }
            }
            Section(header: Text("User Info")) {
                editableTextField(title: "Name", value: $name, editing: $editingName)
                editableTextField(title: "Job Title", value: $profession, editing: $editingProfession)
                editableTextField(title: "Email", value: $email, editing: $editingEmail)
            }
            Button("Update Profile") {
                updateProfile()
            }
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
        UserManager.shared.currentUser = currentUser

        UserManager.shared.updateProfileData() { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
            } else {
                print("Profile updated")
            }
        }
        
    }

}


@ViewBuilder
private func editableTextField(title: String, value: Binding<String>, editing: Binding<Bool>) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .aspectRatio(contentMode: .fit)
            .font(.headline)
        HStack {
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
}
