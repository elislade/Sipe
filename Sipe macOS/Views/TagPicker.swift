import SwiftUI

struct TagPicker: View {
    @EnvironmentObject var data:FIRData
    @State private var newTag = ""
    
    var picked: (FIRData.Tag?) -> Void = { _ in }
    
    let randColor = OSColor(
        red: .random(in: 0.2...0.8),
        green: .random(in: 0.2...0.8),
        blue: .random(in: 0.2...0.8),
        alpha: 1
    )
    
    func create() {
        let t = FIRData.Tag(data, name: newTag, color: randColor)
        t.create()
        picked(t)
    }
    
    func tagFilter(_ tag:FIRData.Tag) -> Bool {
        if newTag.count == 0 {
            return true
        } else {
            return tag.name.lowercased().contains(self.newTag.lowercased())
        }
    }
    
    var body: some View {
         VStack(spacing:0) {
            HStack {
                Text("Pick a Tag").font(.system(size: 18, weight: .bold, design: .serif))
                Spacer(minLength: 30)
                Button(action: { self.picked(nil) }){
                    Text("Close")
                }
            }.padding(8)
            
            Divider()
            
            ScrollView {
                VStack(spacing:0) {
                    HStack {
                        Circle().frame(width: 20, height: 20).foregroundColor(Color(randColor))
                        TextField("Type your tag", text: $newTag)//.font(.postSubtitle)
                        Spacer()
                        if newTag.count > 2 {
                            Button(action: create){ Text("Add")}
                        }
                    }.padding(8)
                    
                    ForEach(self.data.tags.filter(tagFilter), id:\.id){ tag in
                        Button(action: { self.picked(tag) }){
                            HStack {
                                Circle().frame(width: 20, height: 20).foregroundColor(Color(tag.color))
                                Text(tag.name)//.font(.postSubtitle)
                                Spacer()
                            }
                            .padding(8)
                            .foregroundColor(.primary)
                        }.overlay(Divider(), alignment: .top)
                    }
                }
            }
            Spacer()
        }
         .buttonStyle(PlainButtonStyle())
    }
}

struct TagPicker_Previews: PreviewProvider {
    static var previews: some View {
        TagPicker()
    }
}
