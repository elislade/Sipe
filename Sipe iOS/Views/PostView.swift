import SwiftUI

struct PostView: View {
    
    let post: Post
    @State private var title = ""
    @State private var content = ""
    
    func update(){
        
    }
    
    var canUpdate: Bool {
        post.content != content || post.title != title
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            TagsView(tags: post.tags, removedTag: { _ in })
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
        PostView(post: Post(title: "Hello", content: "World"))
    }
}
