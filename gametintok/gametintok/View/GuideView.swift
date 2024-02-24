
import SwiftUI

struct GuideView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ScrollView(.vertical,showsIndicators: false)
        {
            VStack(alignment: HorizontalAlignment.center,spacing: 20)
            {
                Header()
                Spacer(minLength: 10)
                Text("Get Started")
                    .fontWeight(.black)
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                
                Text(" Discover new videos ").lineLimit(nil)
                
                Spacer(minLength: 10)
                
                VStack(alignment: HorizontalAlignment.center,spacing: 25)
                {
                    Guide(title: "Like", subtitle: "Swipe Right", desc: "Do you like this video? Touch the screen and swipe right", icon: "heart")
                    Guide(title: "Dismiss", subtitle: "Swipe Left", desc: "Would you rather skip this video? Touch the screen and swipe left", icon: "xmark")
                }
                
                Spacer(minLength: 10)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Continue".uppercased())
                        .font(.headline)
                        .padding()
                        .frame(minWidth: 0,maxWidth: .infinity)
                        .background(Capsule().fill(Color.blue))
                        .foregroundColor(Color.white)
                    
                }
                
                
            }.frame(minWidth: 0,maxWidth: .infinity)
                .padding(.top, 15)
                .padding(.bottom, 25)
                .padding(.horizontal, 25)
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    @State static var alert:Bool = false
    static var previews: some View {
        GuideView()
    }
}
