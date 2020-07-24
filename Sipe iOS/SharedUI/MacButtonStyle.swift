import SwiftUI

struct MacButtonStyle: ButtonStyle {
  
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.font(.postBody)
            .padding(.horizontal, 12)
            .frame(height: 26)
            //.background(Color.accentColor.opacity(0.1))
            .background(ZStack {
                RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1).opacity(0.5)
            })
            .background(LinearGradient.primaryBlue)
            .cornerRadius(4)
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.2 : 1)
    }
}
