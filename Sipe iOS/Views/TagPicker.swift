import SwiftUI

struct TagPicker: View {
    @ObservedObject private var data = FIRData<Tag>()
    @State private var newTag = ""
    
    var picked: (Tag?) -> Void = { _ in }
    
    let randColor = OSColor(
        red: .random(in: 0.2...0.8),
        green: .random(in: 0.2...0.8),
        blue: .random(in: 0.2...0.8),
        alpha: 1
    )
    
    func create() {
        let t = Tag(name: newTag, color: randColor.cgColor)
        t.create()
        picked(t)
    }
    
    func tagFilter(_ tag: Tag) -> Bool {
        if newTag.count == 0 {
            return true
        } else {
            return tag.name.lowercased().contains(newTag.lowercased())
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Pick a Tag").font(.system(size: 24, weight: .bold, design: .serif))
                Spacer()
                Button(action: { picked(nil) }){
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:26)
                        .foregroundColor(.primary).opacity(0.3)
                }
            }.padding()
            
            Divider()
            
            ScrollView {
                VStack(spacing:0) {
                    HStack {
                        Circle().frame(width: 20, height: 20).foregroundColor(Color(randColor))
                        TextField("Type your tag", text: $newTag).font(.postSubtitle).padding(.vertical)
                        Spacer()
                        if newTag.count > 2 {
                            Button(action: create){
                                Image(systemName: "plus.circle.fill").resizable().scaledToFit().frame(width: 26)
                            }
                        }
                    }
                    ForEach(data.collection.filter(tagFilter), id:\.id){ tag in
                        Button(action: { picked(tag) }){
                            HStack {
                                Circle().frame(width: 20, height: 20)//.foregroundColor(Color(tag.color))
                                Text(tag.name).font(.postSubtitle)
                                Spacer()
                            }
                            .padding()
                            .foregroundColor(.primary)
                        }.overlay(Divider(), alignment: .top)
                    }
                }
            }
            Spacer()
        }
    }
}

struct TagPicker_Previews: PreviewProvider {
    static var previews: some View {
        TagPicker()
    }
}
