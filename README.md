# SwiftDemoApp

This App displays videos to users.
On Launch, Video plays and you should see an overlay with two buttons.
? - Guide will tell users how to interact
i - Stats of how many videos user has liked and disliked

User can then swipe videos to like or dislike them.
On swipe, an entry is entered in the Interests table that captures user's reaction to the video.
Another entry is made to the Users table to capture how many videos user has liked  or disliked till date.


Used local Database SQLite - It consists of 3 tables
Users - User details like, name, id, number of videos liked, number of videos disliked
VideoContent - Static data mainly containing video id, url and catageory of videos
Interests - Data about user interactions with a videos, user id, video id and reaction. 1 - Like, 0 - Dislike


Users
-Primary Key - UserId
-name
-videos like counter
-videos dislike counter

VideoContent
-Primary Key - VideoId
-url
-categeory

Interests
-Primary Key - Id
-UserId - ForeignKey referencing user table
-VideoID - ForeignKey referencing video table

For now, I only display users like/dislike counter.
But it can be expanded pretty easily to print user's reactions to videos by just querying the users table.


This project uses SQLite library - https://github.com/stephencelis/SQLite.swift

If the project doesn't run as is, please import the above library by going to the git link and following the manual steps to install the library
which as dragging the .xcodeproject in this project and changing the framework setting in Project.
