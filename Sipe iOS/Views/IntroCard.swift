import SwiftUI

struct IntroCard: View {
    let copy = "If you need finer control over the styling of the text, you can use the same modifier to configure a system font or choose a custom font. You can also apply view modifiers like bold() or italic() to further adjust the formatting."
    
    var body: some View {
        VStack(spacing: 14){
            Image(systemName: "paragraph")
                .resizable().scaledToFit().frame(width: 36)
                .foregroundColor(.orange).opacity(0.5)
            Text("Introduction").font(.postTitle)
            Text(copy).font(.postBody).lineLimit(5).lineSpacing(4).opacity(0.5)
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5))
                RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.2))
            }
        )
    }
}

struct IntroCard_Previews: PreviewProvider {
    static var previews: some View {
        IntroCard()
    }
}
