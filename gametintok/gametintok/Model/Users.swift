
import Foundation

class Users
{
    var userId : Int = 0
    var username : String = ""
    var email: String = ""
    var videosLiked: Int = 0
    var videosDisliked: Int = 0
    
    init(id: Int, name: String, email:String,videosLiked:Int,videosDisliked:Int)
    {
        userId = id
        username = name
        self.email = email
        self.videosLiked = videosLiked
        self.videosDisliked = videosDisliked
    }
    
    
}
