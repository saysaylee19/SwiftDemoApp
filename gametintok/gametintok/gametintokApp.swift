//
//  gametintokApp.swift
//  gametintok
//
//  Created by saylee.mhatre on 2/21/24.
//

import SwiftUI
import AVKit

@main
struct gametintokApp: App {
    
    
     var dbInst = AppInstance()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dbInst)
               
        }
    }
}

//Maintains Stack of Card and AVPlayer objects
class AppInstance: ObservableObject {
    @Published var db: DBUtil = DBUtil()
    @Published var players: [InstanceObj] = []
    
    func peek() -> InstanceObj {
            guard let topElement = players.last else { fatalError("This stack is empty.") }
            return topElement
        }
    
     func pop() -> InstanceObj {
          
            var o =  players.removeLast()
         return o
        }
    
    func addEntry(id:Int,player: AVPlayer)
    {
        
        var o = InstanceObj(id: id, player: player)
        push(o)
        
    }
    
     func push(_ element: InstanceObj) {
         if players.count > 0
         {
             element.player.pause()
         }
         else
         {
             element.player.play()
         }
        players.insert(element, at: 0)
       }
    
    func getPrev()-> InstanceObj {
         
        guard let topElement = players.first else { fatalError("This stack is empty.") }
        return topElement
       }
    
}



struct InstanceObj
{
    var id: Int
    var player: AVPlayer
}
