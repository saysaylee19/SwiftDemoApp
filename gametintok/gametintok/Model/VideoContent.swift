
import SwiftUI

struct VideoContent
{
    var videoId : Int
    var catageory : String
    //var image: String
    var url:String
 
    init(videoId: Int, catageory: String, url:String)
    {
        self.videoId = videoId
        self.catageory = catageory
        self.url = url
    
    }
}
