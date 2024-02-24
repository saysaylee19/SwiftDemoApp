import SwiftUI
import AVKit

//Consists Video Player and is Child View

struct CardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    @StateObject private var playerViewModel = PlayerViewModel()
    @State var currentUser : Users? = nil
    
    @EnvironmentObject var inst: AppInstance
    
    private var card: Card
    private var onRemove: (_ card: Card) -> Void
    private var isTop: Bool
    
    @State var counter:Int = 0
    @State var likecounter:Int = 0
    @State var dislikecounter:Int = 0
    
    private var thresholdPercentage: CGFloat = 0.4 //% of screen drag
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(card: Card, onRemove: @escaping (_ card: Card) -> Void, isTop: Bool) {
        self.card = card
        self.onRemove = onRemove
        self.isTop = isTop
    }
    
    //Get current drag percent
    private func getDragPercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    //Get Current active user- Should be 12
    private func getCurrentUser()->Users{
        
        if currentUser == nil
        {
            currentUser = inst.db.getCurrentUser()
        }
        return currentUser!
    }
    
    var body: some View {

        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: self.swipeStatus == .like ? .leading : .trailing) {
                    
                    //video player
                    if let avPlayer = playerViewModel.avPlayer {
                        VideoPlayer(player: avPlayer)
                    }
                    // Like/ Dislike Overlay
                    if self.swipeStatus == .like {
                        Image(systemName: "heart")
                            .resizable()
                            .font(.headline)
                            .cornerRadius(10)
                            .foregroundColor(Color.blue)
                            .padding()
                            .modifier(LikeDislikeModifier())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 3.0)
                            ).padding(.top, 45)
                    } else if self.swipeStatus == .dislike {
                        Image(systemName: "xmark")
                            .resizable()
                            .font(.headline)
                            .padding()
                            .modifier(LikeDislikeModifier())
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 3.0)
                            ).padding(.top, 45)
                    }
                }
            }
            .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .onAppear{
                //Load avplayer only after view appears
                playerViewModel.loadFromUrl(url: self.card.url)
                //Add Entry to our stack for tracking
                inst.addEntry(id: card.id, player: playerViewModel.avPlayer!)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        //Pause video when drag begins
                        inst.peek().player.pause()
                        if (self.getDragPercentage(geometry, from: value)) >= self.thresholdPercentage {
                            self.swipeStatus = .like
                        } else if self.getDragPercentage(geometry, from: value) <= -self.thresholdPercentage {
                            self.swipeStatus = .dislike
                        } else {
                            self.swipeStatus = .none
                        }
                        
                }.onEnded { value in
                        if abs(self.getDragPercentage(geometry, from: value)) >
                            self.thresholdPercentage {
                            
                            var reaction = 0
                            if self.swipeStatus == .like {
                                if( counter < Int.max)
                                {
                                    counter += 1
                                }
                                //Increment counters for storing reactions in DB
                                likecounter+=1
                                reaction = 1
                            }
                            else if self.swipeStatus == .dislike {
                                if( counter > 0)
                                {
                                    counter -= 1
                                }
                                //Increment counters for storing reactions in DB
                                dislikecounter+=1
                                reaction = 0
                            }
                            
                            //Add user's reaction to DB
                            inst.db.insertInterest(userId: getCurrentUser().userId, vidId: card.url, reaction: reaction)
                            //Update user's like and dislike counter
                            inst.db.updateUserLikeCounter(userId: getCurrentUser().userId, liked: likecounter, disLiked: dislikecounter)
                            //Remove current player from stack
                            inst.pop()
                            inst.peek().player.play()
                            self.onRemove(self.card)
                       }
                    }
            )
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(id: 1, catageory: "fifa", url: ""),
                 onRemove: { _ in
                    // do nothing
            },isTop: true)
            .frame(height: 400)
            .padding()
            .environmentObject(AppInstance())
    }
}
