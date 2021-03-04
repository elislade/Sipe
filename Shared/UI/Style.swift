import Foundation
import SwiftUI

#if os(macOS)

typealias OSFont = NSFont
typealias OSFontDescriptor = NSFontDescriptor
typealias OSColor = NSColor

#else

typealias OSFont = UIFont
typealias OSFontDescriptor = UIFontDescriptor
typealias OSColor = UIColor

#endif

extension CGFloat {
    static let MEDIUM_WIDTH: CGFloat = 500
}

extension Font {
    static let postTitle:Font = .system(size: 32, weight: .black, design: .serif)
    static let postSubtitle:Font = .system(size: 18, weight: .bold, design: .serif)
    static let postBody:Font = .system(size: 16, weight: .medium, design: .serif)
}

extension Gradient {
    static let blueFade = Gradient(
        colors: [Color.blue.opacity(0.28), Color.blue.opacity(0.07), Color.blue.opacity(0)]
    )
    
    static func fade(_ c: Color) -> Gradient {
        Gradient(colors: [c.opacity(0.3), c.opacity(0.6)])
    }
    
    static func blue() -> Gradient {
        Gradient(colors: [
            Color(red: 124/255, green: 198/255, blue: 255/255),
            Color(red: 53/255, green: 126/255, blue: 221/255)
        ])
    }
    
    static let titleBarLight = Gradient(colors: [
        Color(red: 228/255, green: 228/255, blue: 228/255),
        Color(red: 205/255, green: 205/255, blue: 205/255)
    ])
    
    static let titleBarDark = Gradient(colors: [
        Color(red: 88/255, green: 88/255, blue: 88/255),
        Color(red: 35/255, green: 35/255, blue: 35/255)
    ])
}

extension LinearGradient {
    static let main = LinearGradient(
        gradient: .blueFade,
        startPoint: .top,
        endPoint: .bottom
    )
    
    static func titleBar(_ s:ColorScheme) -> LinearGradient {
        LinearGradient(
            gradient: s == .light ? .titleBarLight : .titleBarDark,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static let primaryBlue = LinearGradient(
        gradient: .blue(),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static func fade(_ c: Color) -> LinearGradient {
        LinearGradient(
            gradient: .fade(c),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Animation {
    static let main = Animation.spring().speed(1.8)
}

extension AnyTransition {
    static let modalMove = AnyTransition.move(edge: .bottom)//.combined(with: .opacity)
}

struct Style {
    static let btnMac = MacButtonStyle()
}
