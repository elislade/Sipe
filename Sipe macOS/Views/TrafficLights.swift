import SwiftUI

struct TrafficLights: View {
    
    @EnvironmentObject private var w: WindowRef
    @State private var active = true
    
    var shape: some View {
        ZStack{
            Circle()
            Circle().inset(by: 0.25).stroke(Color.black.opacity(0.25), lineWidth: 0.5)
        }
    }
    
    var body: some View {
        HStack(spacing: 8){
            Button(action: w.close){ shape }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.red)
            
            Button(action: w.minimize){ shape }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.orange)
            
            Button(action: w.fullscreen){ shape }
                .frame(width: 13, height: 13)
                .buttonStyle(PlainButtonStyle()).foregroundColor(.green)
                //.disabled(true)
        }
        //.background(active ? Color.red : Color.blue)
        //.onReceive(NSApp.publisher(for: \.isVisable), perform: { self.active = $0 })
    }
}
