//
//  WindowDraggable.swift
//  Sipe macOS
//
//  Created by Eli Slade on 2020-05-03.
//

import SwiftUI

struct WindowDraggable: ViewModifier {
    @EnvironmentObject private var window: WindowRef
    
    func body(content: Content) -> some View {
        content.gesture(DragGesture(coordinateSpace: .local).onChanged({ g in
            self.window.update(offset: g.translation)
        }))
    }
}


extension View {
    func windowDraggable() -> some View {
        modifier(WindowDraggable())
    }
}
