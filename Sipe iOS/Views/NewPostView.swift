import SwiftUI
import CoreLocation

struct NewPostView: View {
    @Environment(\.colorScheme) var scheme
    
    //@EnvironmentObject var data: FIRData<>
    
    @State private var title = ""
    @State private var content = ""
    @State private var tags: [Tag] = []
    @State private var addTag = false
    
    let locManager = CLLocationManager()
    
    @State private var location: CLLocation?
    
    var created: () -> Void = {}
    
    func create() {
        let c: CLLocationCoordinate2D? = locManager.location?.coordinate
        let l: Location? = c != nil ? Location(coord: c!) : nil
        Post(title: title, content: content, tags: tags, location: l).create()
        created()
    }
    
    
    func listenToLocation() {
        locManager.requestWhenInUseAuthorization()
        // locManager.delegate = d
        // locManager.requestLocation()
        // location = locManager.location
    }
    
    var TagButton: some View {
        Button(action: { self.addTag = true }){
            HStack(spacing:3) {
                Image(systemName: "tag.fill").imageScale(.small)
                // Image(systemName: "plus").imageScale(.small)
            }
            .padding(.horizontal, 7)
            .frame(height: 28)
            .background(Color.primary.opacity(0.3))
            .cornerRadius(14)
            .foregroundColor(.white)
        }
    }
    
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing: 16) {
                Text("New Post").font(.system(size: 24, weight: .bold, design: .serif))
                Spacer()
                Button(action: created){
                    Image(systemName: "trash.circle.fill")
                        .resizable().scaledToFit().frame(width:26)
                        .foregroundColor(.primary).opacity(0.3)
                }
                
                Button(action: create){
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill").imageScale(.small)
                        Text("Publish").font(.subheadline).fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(height: 28)
                    .padding(.horizontal, 8)
                    .background(Color.accentColor)
                    .cornerRadius(14)
                }
            }.padding()
            
            Divider()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    if tags.count > 0 {
                        ScrollView(.horizontal, showsIndicators: false){
                            TagsView(tags: tags)
                        }
                        .cornerRadius(14)
                        .overlay(TagButton, alignment: .trailing)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    VStack {
                        HStack {
                            TextField("Title", text: $title).font(.postTitle)
                            Spacer()
                            if tags.count == 0 {
                                TagButton
                            }
                        }
                        
                        TextView(text: $content)
                            .background(
                                Text("Start typing your story...").font(.postBody)
                                    .opacity(content.count == 0 ? 0.5 : 0).allowsHitTesting(false)
                            , alignment: .topLeading)
                            .frame(height: 300).font(.postBody)
                    }.padding(.horizontal).padding(.top, 6)
                    
                    Spacer()
                }
            }.sheet(isPresented: $addTag){
                TagPicker(picked: {
                    if let tag = $0 {
                        self.tags.append(tag)
                    }
                    self.addTag = false
                })
                .background(LinearGradient.main)
                .background(self.scheme == .light ? Color.white : Color(red: 0.08, green: 0.08, blue: 0.1))
                .edgesIgnoringSafeArea(.all)
            }.onAppear(perform: listenToLocation)
        }
        
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
