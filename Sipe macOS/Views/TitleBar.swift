import SwiftUI

struct TitleBar: View {
    @Environment(\.colorScheme) var cs
    @Binding var write:Bool
    
    @State var trailingView:AnyView?
    
    var body: some View {
        HStack {
            TrafficLights()
            Spacer()
            Text("Sipe").font(.system(size:24, weight: .light, design: .serif))
            Spacer()
            
            //trailingView
            
            if !write {
                Button("Write", action: {
                   withAnimation(.main) {
                       self.write = true
                   }
                }).buttonStyle(Style.btnMac).padding(.vertical)
            }
        }
        .padding(.horizontal, 10).frame(height: 44)
        .background(LinearGradient.titleBar(cs))
        //.shadow(color: .red, radius: 0, x: 0, y: -1)
        //.background(LinearGradient.fade(cs == .dark ? .black : .white))
        .overlay(Divider(), alignment: .bottom)
        .onPreferenceChange(ViewKey.self, perform: {
            print($0)
            self.trailingView = $0.first?.v
        }).windowDraggable()
    }
}

struct TitleBar_Previews: PreviewProvider {
    static var previews: some View {
        TitleBar(write: .constant(false))
    }
}

extension View {
    func titleBarTrailingView<V:View>(_ v:V, id:UUID) -> some View {
        print(id)
        return preference(key: ViewKey.self, value: [ IDView(id: id, v: AnyView(v)) ])
    }
    
    func titleBarLeadingView<V:View>(_ v:V) -> some View {
        self
    }
}

struct ViewKey:PreferenceKey {
    static var defaultValue: [IDView] { [] }
    
    static func reduce(value: inout [IDView], nextValue: () -> [IDView]) {
        value.append(contentsOf: nextValue())
        //value = nextValue()
    }
}

struct IDView: Identifiable, Equatable {
    static func == (lhs: IDView, rhs: IDView) -> Bool {
        lhs.id == rhs.id
    }
    let id:UUID
    let v:AnyView
}
