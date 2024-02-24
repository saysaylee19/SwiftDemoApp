import SwiftUI

struct LikeDislikeModifier: ViewModifier {
    func body (content: Content) -> some View {
        content
            .frame(width: 80,height: 80)
            .foregroundColor(Color.white)
            .font(.system(size: 128))
            .shadow(color: Color(UIColor(red : 0,green:0,blue:0,alpha:0.2)),radius: 12,x:0,y:0)
    }
}

