import SwiftUI

struct HomeView: View {
    @EnvironmentObject var data:FIRData
    @Binding var write:Bool
    
    let trID = UUID()
    
    var body: some View {
        VStack(spacing: 0) {
            // TitleBar()
            
           ScrollView {
               HStack {
                   Spacer()
                   VStack {
                        ForEach(data.posts, id: \.id){ post in
                            HStack(alignment:.top){
                                PostCell(post: .constant(post))
                                Button("...", action:{})
                            }
                            .padding()
                            .background(ZStack{
                                Color(.textBackgroundColor)
                                RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).opacity(0.2)
                            })
                            .cornerRadius(8)
                            .padding(.bottom, 50)
                            .contextMenu {
                                 Button(action: post.delete){ Text("Delete") }
                                 Button(action: {}){ Text("Share") }
                                 Button(action: {}){ Text("Report") }
                            } 
                       }
                   }
                   .padding(.vertical)
                   .frame(minWidth: 300, maxWidth: .MEDIUM_WIDTH)
                   //.blendMode(.darken)
                   .animation(.main)
                    .titleBarTrailingView(Text("Boo!"), id: trID)
                   
                   Spacer()
               }
           }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(write:.constant(false))
    }
}
