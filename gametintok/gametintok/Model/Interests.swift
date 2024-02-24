

import Foundation

struct Interests
{
    var id : Int
    var userId : Int
    var vidId : String
    var reaction: Int
    
    
    init(id:Int,userid: Int, vidId: String, reaction:Int)
    {
        self.id = id
        self.userId = userid
        self.vidId = vidId
        self.reaction = reaction
    }
}
