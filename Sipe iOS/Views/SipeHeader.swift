import SwiftUI
import Firebase

struct SipeHeader: View {
    
    @Environment(\.colorScheme) var scheme
    
    let auth = Auth.auth()
    
    @State var expanded = true
    @State var createPost = false
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 10){
                Text("Sipe").font(.system(size:52, weight: .light, design: .serif))
                     .scaleEffect(expanded ? 1 : 0.5)
                
                if expanded {
                    Text("Writing that takes you places.")
                        .font(.system(size: 20, weight: .regular, design: .serif)).opacity(0.5)
                }
                
                if auth.currentUser != nil {
                    Button(action: { self.createPost = true }){
                        HStack(spacing: 4) {
                            Image(systemName: "paperplane.fill").imageScale(.small)
                            Text("Write").font(.subheadline).fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(height: 28)
                        .padding(.horizontal, 8)
                        .background(Color.accentColor)
                        .cornerRadius(14)
                    }.padding(.top)
                    
                    Button("Log out", action: { try? auth.signOut() })
                }
            }
            Spacer()
        }
        .padding(.top, 20)
        .frame(height: expanded ? 300 : 50)
        .sheet(isPresented: $createPost){
            NewPostView(created: { createPost = false })
                .background(LinearGradient.main)
                .background(scheme == .light ? Color.white : Color(red: 0.08, green: 0.08, blue: 0.1))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SipeHeader_Previews: PreviewProvider {
    static var previews: some View {
        SipeHeader()
    }
}
