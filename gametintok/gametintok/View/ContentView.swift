
import SwiftUI

import AVKit

struct Card: Hashable, CustomStringConvertible {
    var id : Int
    var catageory : String
    var url:String
    
    var description: String {
        return "\(url), id: \(id)"
    }
}

class PlayerViewModel: ObservableObject {

    @Published var avPlayer: AVPlayer?

    func loadFromUrl(url: String) {
        avPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: url, ofType: "mp4")!))
    }
    
}

//Displays inner CardView and is Parent View

struct ContentView: View {
    
    @EnvironmentObject var inst: AppInstance
    
    @State var showGuide:Bool = false;
    @State var showStats:Bool = false;
    
    
    @State private var lastCardIdx : Int = 1
    
    //Preload only 2 videos for better performance
    @State var deck:[Card] = {
            var views = [Card]()
    
            for idx in 0..<2 {
    
                views.append(video[idx])
            }
            return views
        }()
    
    private func getCardViewOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(deck.count - 1 - id) * 10
    }
    
    private var maxID: Int {
        return self.deck.map { $0.id }.max() ?? 0
    }
    
    //Keep adding 1 video to the deck
    private func moveCards()
        {
            self.lastCardIdx += 1
    
            let newVid = video[lastCardIdx % video.count]  ///Non stop loop - todo
            self.deck.append(newVid)
    
        }
    
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(spacing: 25) {
                    ZStack {
                        ForEach(deck.reversed(), id: \.self) { card in
                            if (self.maxID - 5)...self.maxID ~= card.id {
                                //Display child cards
                                CardView(card: card, onRemove: { removedCard in
                                    // Remove that user from our array
                                    self.deck.removeAll { $0.id == removedCard.id }
                                    moveCards()
                                    
                                },isTop: card.id == 4)
                                .animation(.spring())
                                .frame(minWidth: 0,maxWidth: .infinity,minHeight: 0,maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                            }
                        }
                        .overlay(alignment: .topLeading){
                            //Display overlay buttons for stats
                            Button(action: {
                                self.showStats.toggle()
                            }){
                                Image(systemName: "info")
                                    .resizable()
                                    .frame(width:35.0,height: 35.0)
                            }.accentColor(Color.pink)
                                .sheet(isPresented: $showStats )
                            {
                                InfoView()
                            }
                            Spacer()

                            Spacer()
                        }
                        .overlay(alignment: .topTrailing){
                            Button(action: {
                                self.showGuide.toggle()
                            }){
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .frame(width:35.0,height: 35.0)
                            }.accentColor(Color.pink)
                                .sheet(isPresented: $showGuide )
                            {
                                GuideView()
                            }

                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppInstance())
    }
}
