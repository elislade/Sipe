import SwiftUI

struct TrafficLights: View {
    
    @EnvironmentObject var w:WindowRef
    @State var active = true
    
    var body: some View {
        let c = ZStack{
            Circle()
            Circle().inset(by: 0.25).stroke(Color.black.opacity(0.25), lineWidth: 0.5)
        }
        
        return HStack(spacing: 8){
            Button(action: w.close){ c }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.red)
            
            Button(action: w.minimize){ c }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.orange)
            
            Button(action: w.fullscreen){ c }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.green)
                //.disabled(true)
        }
        //.background(active ? Color.red : Color.blue)
        //.onReceive(NSApp.publisher(for: \.isVisable), perform: { self.active = $0 })
    }
}
