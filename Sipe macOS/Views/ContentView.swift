import SwiftUI
import Firebase

struct ContentView: View {
    @Environment(\.colorScheme) var cs
    
    @State private var write = false
    @State private var user: User? = Auth.auth().currentUser
    
    func signIn(){
        
    }
    
    var body: some View {
        ZStack {
            if let user = user {
                HomeView(write: $write)
                Text("UID: \(user.uid)")
            } else {
                VStack {
                    Text("You are logged out!")
                    Button("Sign In", action: signIn)
                }.padding(80)
            }
            
            if write {
                Color.black.opacity(0.5).transition(.opacity).onTapGesture { self.write = false }
                ComposeView(presented: $write)
                    .background(LinearGradient.main)
                    .background(Color.white)
                    .transition(.modalMove)
                    .zIndex(100)
            }
        }
        .window($write)
        .background(LinearGradient.main)
        .background(cs == .light ? Color.white : Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(12)
        .shadow(radius: 50)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
