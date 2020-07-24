import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data:FIRData
    
    @State var error:String?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    SipeHeader()
                    
                    if data.posts.count == 0 {
                        IntroCard().padding(.horizontal).padding(.bottom, 60).frame(minWidth: 200, maxWidth: 550)
                    }
                    
                    if data.user == nil {
                        Text("Not Logged In").opacity(0.3)
                        Button("Sign In", action: data.signIn)
                    } else {
                        ForEach(data.posts, id:\.id){ post in
                            PostCell(post: .constant(post))
                                .frame(maxWidth: 500)
                                .padding()
                                .contextMenu {
                                    Button(action: post.delete){
                                        Image("trash_ctx_menu")
                                        Text("Delete")
                                    }
                                    Button(action: { }){
                                        Image("warn_ctx_menu")
                                        Text("Report")
                                    }
                                    Button(action: { }){
                                        Image("share_ctx_menu")
                                        Text("Share")
                                    }
                                }.padding(.bottom, 60)
                        }
                    }
                }
            }
            
            if error != nil {
                VStack {
                    Spacer()
                    HStack(spacing: 10){
                        Image(systemName: "xmark.octagon.fill").imageScale(.large)
                        Text(error!)
                        Spacer()
                        Button("Okay", action: { self.error = nil })
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(4)
                            .foregroundColor(.white)
                    }
                    .foregroundColor(.red)
                    .padding(20)
                    .padding(.bottom, 20)
                    .background(Color.red.opacity(0.1))
                    .background(Color(.systemBackground))
                    .cornerRadius(5)
                    .shadow(radius: 20)
                }.transition(.modalMove)
            }
        }
        .onReceive(data.errors, perform: { self.error = $0 })
        .animation(.main)
        .background(LinearGradient.main.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
