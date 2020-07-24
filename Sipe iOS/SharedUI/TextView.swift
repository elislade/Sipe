import SwiftUI
import Combine

#if os(macOS)

typealias ViewRepresentable = NSViewRepresentable
typealias ViewType = NSTextView
typealias ViewTypeDelegate = NSTextViewDelegate

#else

typealias ViewRepresentable = UIViewRepresentable
typealias ViewType = UITextView
typealias ViewTypeDelegate = UITextViewDelegate

#endif

struct TextView {
    
    @Binding var text:String
    
    @State var fontSize:CGFloat = 16
    @State var fontWeight:OSFont.Weight = .medium
    @State var fontDesign:OSFontDescriptor.SystemDesign = .serif
    @State var lineSpacing:CGFloat = 2
    
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
            view.font = OSFont(descriptor: d, size: $fontSize.wrappedValue)
        }
        return view
    }
    
    func updateView(_ view: ViewType, context: Context) {
        //
    }
    
    let layout = LayoutCoordinator()
    
    class LayoutCoordinator:NSObject, NSLayoutManagerDelegate {
        func layoutManager(
            _ layoutManager: NSLayoutManager,
            lineSpacingAfterGlyphAt glyphIndex: Int,
            withProposedLineFragmentRect rect: CGRect
        ) -> CGFloat {
            return 2
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(_text)
    }

}

#if os(macOS)

extension TextView: NSViewRepresentable {
    
    func updateNSView(_ nsView: ViewType, context: Context) {
        print("update", text)
        nsView.string = text
    }
    
    func makeNSView(context: Context) -> ViewType {
        let v = makeView(context: context)
        v.layoutManager?.delegate = layout
        return v
    }
    
    class Coordinator:NSObject, ViewTypeDelegate {
        // let layout = LayoutCoordinator()
        @Binding var text:String
        
        init(_ text:Binding<String>) {
            self._text = text
        }
        
        private func textViewDidBeginEditing(_ textView: ViewType) {
            //guard let text = textView.textStorage?.string else { return }
            //host?.didBeginEditing(textView.string)
            text = textView.string
        }
        
        func textViewDidChange(_ textView: ViewType) {
            //guard let text = textView.textStorage?.string else { return }
            //host?.didChange(textView.string)
            text = textView.string
        }
        
        private func textViewDidEndEditing(_ textView: ViewType) {
            //guard let text = textView.textStorage?.string else { return }
            //host?.didFinishEditing(textView.string)
            text = textView.string
        }
    }
}

#else

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
    
    class Coordinator:NSObject, ViewTypeDelegate {
        //let host:EditTextLong
        @Binding var text:String
        
        init(_ text:Binding<String>) {
            self._text = text
        }
        
        func textViewDidBeginEditing(_ textView: ViewType) {
            // host.didBeginEditing(textView.text)
            text = textView.text
        }
        
        func textViewDidChange(_ textView: ViewType) {
            // host.didChange(textView.text)
            text = textView.text
        }
        
        func textViewDidEndEditing(_ textView: ViewType) {
            // host.didFinishEditing(textView.text)
            text = textView.text
        }
    }
}

#endif
