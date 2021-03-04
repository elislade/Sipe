import AppKit
import Combine

class WindowRef:ObservableObject {
    private let window: NSWindow
    private var c: AnyCancellable?
    
    init(_ window: NSWindow){
        self.window = window
        c = window.publisher(for: \.isKeyWindow).sink{
            print("is key",$0)
        }
    }
    
    func close(){ window.close() }
    func minimize(){ window.miniaturize(nil) }
    func fullscreen(){ window.toggleFullScreen(nil) }
    
    func update(offset: CGSize){
        let f = window.frame.offsetBy(dx: offset.width, dy: -offset.height / 2)
        window.setFrame(f, display: true)
    }
}
