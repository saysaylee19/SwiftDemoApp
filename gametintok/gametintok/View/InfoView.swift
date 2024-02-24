

import SwiftUI

struct InfoView: View {
    
    @EnvironmentObject var db: AppInstance
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false)
        {
            VStack(alignment: HorizontalAlignment.center,spacing: 20)
            {
                Header()
                Spacer(minLength: 10)
                Text("User Stats")
                    .fontWeight(.black)
                    .font(.largeTitle)
                    .foregroundColor(Color.blue)
                
                Text(" User likes \(db.db.getCurrentUser().videosLiked) and dislikes \(db.db.getCurrentUser().videosDisliked)").lineLimit(nil)
                
                
                Spacer(minLength: 10)
            
                Spacer(minLength: 10)
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("Close".uppercased())
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

struct InfoView_Previews: PreviewProvider {
    @State static var user = Users(id: 999, name: "Test", email: "text@test.com", videosLiked: 0, videosDisliked: 0)
    static var previews: some View {
        InfoView()
    }
}
