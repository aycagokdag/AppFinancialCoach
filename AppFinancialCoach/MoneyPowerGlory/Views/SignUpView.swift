import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showLogin = false
    @AppStorage("uid") var userID: String = ""
    @State private var user : UserProfileInfoModel?
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
        
            VStack {
                HStack {
                    Text("Create an account!")
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
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    Spacer()
                    
                    if(email.count != 0){
                        Image(systemName: password.isValidPassword() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(password.isValidPassword() ? .green : .red)
                    }
                    
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.showLogin = true
                    }
                }){
                    Text("Have an account already?")
                        .foregroundColor(.black.opacity(0.7))
                    
                }
                .sheet(isPresented: $showLogin) {
                   LoginView()
                }
                
                Spacer()
                Spacer()
                
                Button {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let authResult = authResult {
                            withAnimation {
                                userID = authResult.user.uid
                                user = UserProfileInfoModel(uid: authResult.user.uid, email: email)
                                UserManager.shared.createNewUser(user: user!)
                            }
                        }
                    
                    }
                } label: {
                    Text("Create Account")
                        .foregroundColor(.white)
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
           
        }
    }
}


