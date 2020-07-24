import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var cs
    
    @EnvironmentObject var data:FIRData
    
    @State var write = false
    
    var body: some View {
        ZStack {
            
            if data.user != nil {
                HomeView(write: $write).scaleEffect(write ? 0.95 : 1)
            } else {
                VStack {
                    Text("You are logged out!")
                    Button("Sign In", action: data.signIn)
                }.padding(80)
            }
            
            if write {
                Color.black.opacity(0.5).transition(.opacity).onTapGesture { self.write = false }
                ComposeView(presented: $write)
                    //.background(LinearGradient.main)
                    .background(Color.white)
                    .transition(.modalMove)
                    .zIndex(100)
            }
        }
        .window($write)
        //.background(LinearGradient.main)
        .background(cs == .light ? Color.white : Color.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.cornerRadius(6)
        //.shadow(radius: 50)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
