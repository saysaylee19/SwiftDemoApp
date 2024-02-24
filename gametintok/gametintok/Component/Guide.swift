import SwiftUI

struct Guide: View {
    
    var title: String
    var subtitle:String
    var desc:String
    var icon:String
    
    var body: some View {
        HStack(alignment: .center, spacing: 20)
        {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(Color.blue)
            
            VStack(alignment: .center, spacing: 4)
            {
                HStack(alignment: .center, spacing: 20)
                {
                    Text(title.uppercased())
                        .font(.title)
                        .fontWeight(.heavy)
                    Spacer()
                    Text(subtitle.uppercased())
                        .font(.footnote)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.blue)
                    
                }
                Divider().padding(.bottom,4)
                Text(desc)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
        
                
            }
        }
    }
}

struct Guide_Previews: PreviewProvider {
    static var previews: some View {
        Guide(
        title: "Title", subtitle: "Swipe Right", desc: "Placehoolder Text, Add desc here if possible.", icon: "parchment")
            .previewLayout(.sizeThatFits)
    }
}
