import Cocoa
import SwiftUI
import Firebase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()

        newWindow(from: ContentView())
        newWindow(from: ComposeView(presented: .constant(true)).cornerRadius(10))
    }

    func newWindow<T:View>(from view:T){

        // let mask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        let mask: NSWindow.StyleMask = [.closable, .resizable, .borderless, .miniaturizable]
        
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: mask,
            backing: .buffered, defer: false)
        
        let contentView = view.environmentObject(WindowRef(window))
        
        window.center()
        window.collectionBehavior = [.fullScreenPrimary]
        //window.setFrameAutosaveName("Main Window")
        window.setContentBorderThickness(0, for: .maxX)
        window.contentView = NSHostingView(rootView: contentView)
        window.contentView?.layer?.borderWidth = 0.2
        window.contentView?.layer?.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        window.contentView?.layer?.cornerRadius = 6
        window.backgroundColor = .clear
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

