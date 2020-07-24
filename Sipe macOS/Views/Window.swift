import SwiftUI

struct Window<Content:View>: View {
    
    @Binding var write:Bool
    
    var content:() -> Content
    
    var body: some View {
        VStack(spacing:0) {
            TitleBar(write: $write, trailingView: AnyView(Text("Default")))
            content()
        }
    }
}

extension View {
    func window(_ write:Binding<Bool>) -> some View {
        Window(write: write ) { self }
    }
}
