import SwiftUI
import FirebaseAuth

struct SideMenuView: View {
    @AppStorage("uid") var userID: String = ""
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @State private var showingProfileView = false
    
    var body: some View {
        HStack {

            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: Color("darkPurple").opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                    .frame(height: 140)
                    .padding(.bottom, 30)
                    .onTapGesture {
                        showingProfileView = true
                    }
                    .sheet(isPresented: $showingProfileView) {
                        ProfileView()
                    }
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                    
                    Button(action:{ // sign out button
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            withAnimation{
                                userID = ""
                            }
                        } catch let signOutError as NSError {
                              print("Error signing out: %@", signOutError)
                        }
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Text("Sign out")
                                .font(.headline)
                                .foregroundColor(.black) // Customize the color as needed
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Optional: Add a background color
                        .cornerRadius(10)
                    }
                    
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            }
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
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
            
            Text("Ayca Gökdağ")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text("IOS Developer")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Rectangle()
                        .fill(isSelected ? Color("darkPurple") : .white)
                        .frame(width: 5)
                    
                    ZStack{
                        Image(systemName: imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(isSelected ? .black : .gray)
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? Color("darkPurple").opacity(0.5) : .white, .white], startPoint: .leading, endPoint: .trailing)
        )
    }
}


struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedSideMenuTab = 0
        SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: .constant(false))
    }
}
