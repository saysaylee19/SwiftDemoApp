
import Foundation
import SQLite3

class DBUtil
{
    
    init()
    {
        
        db = openDatabase()
        
        
        //Drop table
        //dropTable(tableName: "interests")
        
        //Create tables
        
        //createUsersTable()
        //createVideoContentTable()
        //createInterestsTable()
        
        
        //Run this once then comment it out
        //Insert User with id 15  in DB
        //insert(id: 15, name: "Tester 1", email: "tester1@test.com", likes: 0,dislikes: 0)
        
    
        //Insert some data in video table
//        insertVideoContent(videoID: 12, catageory: "sims", url: "Sims-1")
//        insertVideoContent(videoID: 13, catageory: "sims", url: "Sims-2")
//        insertVideoContent(videoID: 1, catageory: "sims", url: "Sims-3")
//        insertVideoContent(videoID: 14, catageory: "sims", url: "Sims-4")
//        insertVideoContent(videoID: 15, catageory: "sims", url: "Sims-5")
//        insertVideoContent(videoID: 2, catageory: "apex", url: "Apex-1")
//        insertVideoContent(videoID: 3, catageory: "apex", url: "Apex-2")
//        insertVideoContent(videoID: 4, catageory: "apex", url: "Apex-3")
//        insertVideoContent(videoID: 5, catageory: "apex", url: "Apex-4")
//        insertVideoContent(videoID: 6, catageory: "apex", url: "Apex-5")
        
        //insertInterest(id: 5, userId: 6, vidId: "Sims-1", reaction: 1)
        
        
        //Query interests table
        readInterests()
        
        //Query if user likes a video
//        if doesUserLikeVideo(userID: 12, vidId: "Sims-3") == 1
//        {
//            print("User 12 likes video - Sims-3")
//        }
//        else
//        {
//            print("User 12 does not like video - Sims-3")
//        }
        
    
    
    }
    
    
    let dbPath: String = "myDb.sqlite"
        var db:OpaquePointer?

        func openDatabase() -> OpaquePointer?
        {
            
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(dbPath)
            var db: OpaquePointer? = nil
            
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK
            {
                print("error opening database")
                return nil
            }
            else
            {
                print("Successfully opened connection to database at \(dbPath)")
                return db
            }
        }
    
    func createUsersTable() {
            let createTableString = "CREATE TABLE IF NOT EXISTS users(UserId INTEGER PRIMARY KEY,username TEXT,email TEXT, videosLiked INTEGER, videosDisliked INTEGER);"
            var createTableStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(createTableStatement) == SQLITE_DONE
                {
                    print("Users table created.")
                } else {
                    print("Users table could not be created.")
                }
            } else {
                print("CREATE TABLE statement could not be prepared.")
            }
            sqlite3_finalize(createTableStatement)
        }
    
    func updateUserLikeCounter(userId:Int,liked:Int,disLiked:Int)
    {
        let updateStatementString = "UPDATE users set videosLiked = videosLiked+'\(liked)', videosDisliked = videosDisliked+'\(disLiked)' WHERE UserId = '\(userId)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row with videosLiked = \(liked), videosDisliked = \(disLiked)")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
        
    }
    
    func getCurrentUser()-> Users
    {
        return getUserById(userID: 12)
    }
    
    
    func insert(id:Int, name:String, email:String, likes:Int,dislikes:Int)
    {
        let users = read()
        for u in users
        {
            if u.userId == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO users (UserId, username,email, videosLiked,videosDisliked) VALUES (?, ?, ?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, Int32(likes))
            sqlite3_bind_int(insertStatement, 5, Int32(dislikes))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
    }
    
    
    func read() -> [Users] {
            let queryStatementString = "SELECT * FROM users;"
            var queryStatement: OpaquePointer? = nil
            var users : [Users] = []
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let likes = sqlite3_column_int(queryStatement, 3)
                    let dislikes = sqlite3_column_int(queryStatement, 4)
                    users.append(Users(id: Int(id), name: name, email: email,  videosLiked: Int(likes),videosDisliked: Int(dislikes)))
                    //print("Query Result:")
                    //print("\(id) | \(name) | \(likes)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return users
        }
    
    func getUserById(userID: Int) -> Users {
            let queryStatementString = "SELECT * FROM users where UserId = ?;"
            var queryStatement: OpaquePointer? = nil
            var user : Users? = nil
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1, Int32(userID))
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let likes = sqlite3_column_int(queryStatement, 3)
                    let dislikes = sqlite3_column_int(queryStatement, 4)
                    user = Users(id: Int(id), name: name, email: email, videosLiked: Int(likes),videosDisliked: Int(dislikes))
                    //print("Query Result:")
                    //print("\(id) | \(name) | \(likes) | \(dislikes)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        return user!
        }
    
    
    func deleteByID(id:Int) {
            let deleteStatementStirng = "DELETE FROM person WHERE UserId = ?;"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
        }
    
    
    // Mark - VideoContent

    func createVideoContentTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS video_content(VideoId INTEGER PRIMARY KEY,catageory TEXT,url TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("VideoContent table created.")
            } else {
                print("VideoContent table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared for VideoContent")
        }
        sqlite3_finalize(createTableStatement)
}


func insertVideoContent(videoID:Int, catageory:String, url:String)
{
    let videos = readVideoContent()
    for v in videos
    {
        if v.videoId == videoID
        {
            return
        }
    }
    let insertStatementString = "INSERT INTO video_content (VideoId, catageory,url) VALUES (?, ?, ?);"
    var insertStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
        sqlite3_bind_int(insertStatement, 1, Int32(videoID))
        sqlite3_bind_text(insertStatement, 2, (catageory as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStatement, 3, (url as NSString).utf8String, -1, nil)
        
        if sqlite3_step(insertStatement) == SQLITE_DONE {
            print("Successfully inserted row in video_Content table.")
        } else {
            print("Could not insert row in video_Content table")
        }
    } else {
        print("INSERT statement could not be prepared for video_content table")
    }
    sqlite3_finalize(insertStatement)

}


func readVideoContent() -> [VideoContent] {
    let queryStatementString = "SELECT * FROM video_content;"
    var queryStatement: OpaquePointer? = nil
    var videos : [VideoContent] = []
    if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            let videoid = sqlite3_column_int(queryStatement, 0)
            let catageory = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
            let url = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
            videos.append(VideoContent(videoId: Int(videoid), catageory: catageory, url: url))
            //print("Query Result for VideoContent ")
            //print("\(videoid) | \(catageory) | \(url)")
        }
    } else {
        print("SELECT statement could not be prepared for video_content")
    }
    sqlite3_finalize(queryStatement)
    return videos
}
    
    func getVideoById(vidId: Int) -> VideoContent {
            let queryStatementString = "SELECT * FROM video_content where VideoId = ?;"
            var queryStatement: OpaquePointer? = nil
            var video : VideoContent? = nil
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1, Int32(vidId))
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let videoid = sqlite3_column_int(queryStatement, 0)
                    let catageory = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let url = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    video = VideoContent(videoId: Int(videoid), catageory: catageory, url: url)
                    //print("Query Result for VideoContent ")
                    //print("\(videoid) | \(catageory) | \(url)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        return video!
    }


func deleteByVideoId(id:Int) {
    let deleteStatementStirng = "DELETE FROM video_content WHERE VideoId = ?;"
    var deleteStatement: OpaquePointer? = nil
    if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
        sqlite3_bind_int(deleteStatement, 1, Int32(id))
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("Successfully deleted row from video_content")
        } else {
            print("Could not delete row from video_content")
        }
    } else {
        print("DELETE statement could not be prepared for video_content")
    }
    sqlite3_finalize(deleteStatement)
}
    
    //Features
    
    func createInterestsTable() {
            let createTableString = "CREATE TABLE IF NOT EXISTS interests(Id INTEGER PRIMARY KEY AUTOINCREMENT,userId INTEGER REFERENCES users(UserId),vidId TEXT REFERENCES video_content(VideoId),reaction INTEGER);"
            var createTableStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
            {
                if sqlite3_step(createTableStatement) == SQLITE_DONE
                {
                    print("Interests table created.")
                } else {
                    print("Interests table could not be created.")
                }
            } else {
                print("CREATE TABLE statement could not be prepared for Interests.")
            }
            sqlite3_finalize(createTableStatement)
        }
    
    
    func insertInterest(userId:Int, vidId:String, reaction:Int)
    {
        let insertStatementString = "INSERT INTO interests (userId, vidId,reaction) VALUES (?, ?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(userId))
            sqlite3_bind_text(insertStatement, 2, (vidId as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(reaction))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row in Interests.")
            } else {
                print("Could not insert row in Interests.")
            }
        } else {
            print("INSERT statement could not be prepared for Interests.")
        }
        sqlite3_finalize(insertStatement)
        
    }
    
    
    func readInterests() -> [Interests] {
            let queryStatementString = "SELECT * FROM interests;"
            var queryStatement: OpaquePointer? = nil
            var users : [Interests] = []
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let userId = sqlite3_column_int(queryStatement, 1)
                    let vidId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let reaction = sqlite3_column_int(queryStatement, 3)
                    users.append(Interests(id: Int(id), userid: Int(userId), vidId: vidId, reaction: Int(reaction)))
                    print("Query Result:")
                    print("\(id) | \(userId) | \(vidId) | \(reaction)")
                }
            } else {
                print("SELECT statement could not be prepared for Interests")
            }
            sqlite3_finalize(queryStatement)
            return users
        }
    
    
    func doesUserLikeVideo(userID: Int,vidId: String) -> Interests {
            let queryStatementString = "SELECT * FROM interests where userId = ? and vidId = ?;"
            var queryStatement: OpaquePointer? = nil
            var interst : Interests? = nil
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(queryStatement, 1, Int32(userID))
                sqlite3_bind_text(queryStatement, 2, (vidId as NSString).utf8String, -1, nil)
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let userId = sqlite3_column_int(queryStatement, 1)
                    let vidId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                    let reaction = sqlite3_column_int(queryStatement, 3)
                    interst = Interests(id: Int(id), userid: Int(userId), vidId: vidId, reaction: Int(reaction))
                    print("Query Result for UserLikesVideo:")
                    print("\(id) | \(userId) | \(vidId) | \(reaction)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
        return interst!
        }
    
    
    func dropTable(tableName: String) {
        let dropStatementString = "DROP TABLE '\(tableName)';"
        var dropStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dropStatementString, -1, &dropStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropStatement) == SQLITE_DONE {
                print("Successfully dropped \(tableName)")
            } else {
                print("Could not drop \(tableName)")
            }
        } else {
            print("DROP statement could not be prepared for \(tableName)")
        }
        sqlite3_finalize(dropStatement)
    }
    
    
    
}
