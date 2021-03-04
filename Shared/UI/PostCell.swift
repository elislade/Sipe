import SwiftUI

struct PostCell: View {
    
    let post: Post
    @State var editable = false
    
    var dateString: String {
        var dt = "Date"
        if Calendar.current.isDateInToday(post.createdOn){
            dt = "Today " + DateFormatter.localizedString(from: post.createdOn, dateStyle: .none, timeStyle: .short)
        } else {
            dt = DateFormatter.localizedString(from: post.createdOn, dateStyle: .medium, timeStyle: .none)
        }
        return dt
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading, spacing:1) {
                    HStack {
                        Text(dateString).fontWeight(.bold)
                        Circle().frame(width: 4)
                        HStack(spacing: 1) {
                            // Image(systemName: "tag.fill").imageScale(.small)
                            Text("\(post.tags.count)").fontWeight(.medium)
                        }
                        
                        Spacer()
                    }.font(.caption).opacity(0.4).frame(height: 20)
                    
                    Text(post.title).font(.postTitle)
                }
                Spacer()
                
//                if post.location != nil {
//                    MapView(marker: .constant(Marker(post.location!.clLocation)))
//                        .frame(width: 80, height: 80).cornerRadius(5)
//                }
            }
            
            Text(post.content).font(.postBody)
                .lineSpacing(3).lineLimit(4)
            
        }
    }
}

//struct PostCell_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCell(post: .constant(Post()))
//    }
//}
