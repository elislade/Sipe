import SwiftUI

#if os(macOS)
typealias ViewType = NSTextView
typealias ViewTypeDelegate = NSTextViewDelegate
typealias ViewRepresentable = NSViewRepresentable
#endif

#if os(iOS)
typealias ViewType = UITextView
typealias ViewTypeDelegate = UITextViewDelegate
typealias ViewRepresentable = UIViewRepresentable
#endif

struct TextView {
    
    @Binding var text: String
    
    var fontSize: CGFloat = 16
    var fontWeight: OSFont.Weight = .medium
    var fontDesign: OSFontDescriptor.SystemDesign = .serif
    var lineSpacing: CGFloat = 2
    
    var didBeginEditing: (String) -> Void = { _ in }
    var didChange: (String) -> Void = { _ in }
    var didFinishEditing: (String) -> Void = { _ in }
    
    func makeView(context: Context) -> ViewType {
        let view = ViewType()
        view.isEditable = true
        view.textContainerInset = .zero
        view.delegate = context.coordinator
        view.backgroundColor = .clear
        if let d = OSFont.systemFont(ofSize: fontSize, weight: fontWeight).fontDescriptor.withDesign(fontDesign) {
            view.font = OSFont(descriptor: d, size: fontSize)
        }
        return view
    }
    
    func updateView(_ view: ViewType, context: Context) {
        //
    }
    
    let layout = LayoutCoordinator()
    
    class LayoutCoordinator: NSObject, NSLayoutManagerDelegate {
        func layoutManager(
            _ layoutManager: NSLayoutManager,
            lineSpacingAfterGlyphAt glyphIndex: Int,
            withProposedLineFragmentRect rect: CGRect
        ) -> CGFloat {
            return 2
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator{ text = $0 }
    }
}

protocol TextCoordinator {
    var textChanged: (String) -> Void {get set}
}

#if os(macOS)
extension TextView: NSViewRepresentable {
    
    func makeNSView(context: Context) -> ViewType {
        let v = makeView(context: context)
        v.layoutManager?.delegate = layout
        return v
    }
    
    func updateNSView(_ nsView: ViewType, context: Context) {
        nsView.string = text
    }
    
    class Coordinator: NSObject, ViewTypeDelegate {

        var textChanged: (String) -> Void
        
        init(_ evt: @escaping (String) -> Void) {
            self.textChanged = evt
        }
        
        private func textViewDidBeginEditing(_ textView: ViewType) {
            textChanged(textView.text)
            
        }
        
        func textViewDidChange(_ textView: ViewType) {
            textChanged(textView.text)
        }
        
        private func textViewDidEndEditing(_ textView: ViewType) {
            textChanged(textView.text)
        }
    }
}

extension ViewType{
    var text: String { string }
}
#endif

#if os(iOS)
extension TextView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ViewType {
        let v = makeView(context: context)
        v.text = text
        v.isUserInteractionEnabled = true
        v.layoutManager.delegate = layout
        return v
    }
    
    func updateUIView(_ uiView: ViewType, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    class Coordinator: NSObject, ViewTypeDelegate {
        
        var textChanged: (String) -> Void
        
        init(_ evt: @escaping (String) -> Void) {
            self.textChanged = evt
        }
        
        func textViewDidBeginEditing(_ textView: ViewType) {
            textChanged(textView.text)
        }
        
        func textViewDidChange(_ textView: ViewType) {
            textChanged(textView.text)
        }
        
        func textViewDidEndEditing(_ textView: ViewType) {
            textChanged(textView.text)
        }
    }
    
}
#endif
