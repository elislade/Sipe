import SwiftUI

struct TagsView: View {
    
    let tags: [Tag]
    var editable = true
    var removedTag: (Tag) -> Void = {_ in}
    
    var body: some View {
        return HStack {
            ForEach(tags, id:\.id){ tag in
                HStack {
                    Text(tag.name).font(.footnote).fontWeight(.semibold)
                    
                    if editable {
                        Button(action: { }){
                            Image(systemName: "xmark.circle.fill").opacity(0.7)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(height: 28)
                .padding(.leading, 14)
                .padding(.trailing, editable ? 6 : 14)
                .foregroundColor(.white)
                .background(Color(tag.cgColor))
                .cornerRadius(14)
            }
        }
    }
}
