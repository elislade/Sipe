import SwiftUI

struct PostView: View {
    
    @State var post:FIRData.Post
    @State var title = ""
    @State var content = ""
    
    func update(){
        
    }
    
    var body: some View {
        var canUpdate:Bool {
            post.content != content || post.title != title
        }
        
        return VStack(alignment: .leading) {
            // TagsView(tags: .constant(post.tags ?? []), removedTag: post.removeFromTags)
            HStack {
                TextField("Title", text: $title).lineLimit(0).font(.title)
                Spacer()
            }
            TextView(text: $content)
            Spacer()
        }
        .padding()
        .navigationBarItems(trailing: Button("Update", action: update).disabled(!canUpdate))
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: FIRData.Post(FIRData(), title: "Hello", content: "World"))
    }
}
