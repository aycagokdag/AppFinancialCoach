import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    @AppStorage("uid") var userID: String = ""
    @State private var isPasswordVisible = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert.toggle()
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
        
            VStack {
                HStack {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                Spacer()
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                        .autocapitalization(.none)

                    if(email.count != 0){
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                            .onTapGesture {
                                if !email.isValidEmail() {
                                    showAlert(title: "Invalid email address", message: "The mail should be in the form of example@test.com")
                                }
                            }
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("textColor"))
                )
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                    }
                    Button(action: {
                           isPasswordVisible.toggle()
                       }) {
                           Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                               .foregroundColor(Color("textColor"))
                       }
                    Spacer()
                    
                    if(email.count != 0){
                        Image(systemName: password.isValidPassword() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(password.isValidPassword() ? .green : .red)
                            .onTapGesture {
                                if !password.isValidPassword() {
                                    showAlert(title: "Invalid password", message: "Password should contain at least 8 letters, one uppercase letter, and a special character.")
                                }
                            }
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("textColor"))
                )
                .padding()
                
                Button(action: {
                    print("show sign up clicked")
                    self.showSignUp = true
                }){
                    Text("Don't have an account?")
                        .foregroundColor(Color("textColor").opacity(0.7))
                }
                .sheet(isPresented: $showSignUp) {
                   SignUpView()
                }
                
                Spacer()
                Spacer()
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            userID = authResult.user.uid // setting this makes add expense view visible
                            UserManager.shared.fetchUserData(userID: authResult.user.uid){}
                        }
                    }
                    
                } label: {
                    Text("Sign In")
                        .foregroundColor(Color("darkPurple"))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.horizontal)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
           
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
