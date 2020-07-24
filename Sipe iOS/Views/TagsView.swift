import SwiftUI

struct TagsView: View {
    @Binding var tags:[FIRData.Tag]
    @State var editable = true
    
    var removedTag:(FIRData.Tag) -> Void = {_ in}
    
    var body: some View {
        return HStack {
            ForEach(tags, id:\.id){ tag in
                HStack {
                    Text(tag.name).font(.footnote).fontWeight(.semibold)
                    
//                    if self.editable {
//                        Button(action:{ }){
//                            Image(systemName: "xmark.circle.fill").opacity(0.7)
//                        }
//                    }
                }
                .frame(height: 28)
                .padding(.leading, 14)
                .padding(.trailing, self.editable ? 6 : 14)
                .foregroundColor(.white)
                .background(Color(tag.color))
                .cornerRadius(14)
            }
        }
    }
}
