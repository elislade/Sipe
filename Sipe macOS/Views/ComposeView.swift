import SwiftUI

struct ComposeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var presented: Bool
    
    @State private var title = "Title"
    @State private var content = ""
    @State private var tags: [Tag] = []
    
    @State var picking = false
    
    func compose(){
        Post(title: title, content: content, tags: tags).create()
    }
    
    func discard(){
        withAnimation(.main){
            self.presented = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                TrafficLights()
                
                Text("New Post").font(.postSubtitle)
                Spacer()
                Button(action: discard){
                    // Text("Trash")
                    Image(systemName: "trash")
                }.buttonStyle(Style.btnMac)
                Button("Post", action: compose).buttonStyle(Style.btnMac)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .background(LinearGradient.titleBar(colorScheme))
            .windowDraggable()
            
            Divider()
            
            ScrollView {
                HStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 10) {
                        TagsView(tags: tags)
                        
                        HStack {
                            TextField("Title", text: $title).font(.postTitle)
                            Spacer()
                            Button("Tag", action: { self.picking = true })
                               .popover(isPresented: $picking) {
                                   TagPicker(picked: {
                                       self.picking = false
                                       if let tag = $0 {
                                           self.tags.append(tag)
                                       }
                                   }).frame(minWidth: 220)
                               }
                                           
                        }
                        
                        // TextField("Content", text: $content).font(.postBody)
                        // EditTextLong(text: $title, fontSize: 36, fontWeight: .heavy)
                        
                        TextView(text: $content)
                            .frame(minHeight: 300)
                            .overlay(Text("Start typing...").font(.postBody), alignment: .topLeading)
                    }.frame(minWidth: 300, maxWidth: .MEDIUM_WIDTH)
                    Spacer()
                }.padding()
            }
        }
        .textFieldStyle(PlainTextFieldStyle())
        .background(colorScheme == .light ? Color.white : Color.black)
    }
}

struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeView(presented: .constant(true))
    }
}
