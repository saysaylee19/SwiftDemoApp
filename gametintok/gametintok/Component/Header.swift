import SwiftUI

struct Header: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20)
        {
            Capsule()
                .frame(width: 120,height: 6)
                .foregroundColor(Color.secondary)
                .opacity(0.2)
            
            Image(systemName: "t.circle").resizable().scaledToFit().frame(height: 28)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
            .previewLayout(.fixed(width: 375, height: 100))
    }
}
