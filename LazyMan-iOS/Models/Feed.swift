//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

class Feed {
    
    // MARK: - Properties
    
    let feedType: String
    let callLetters: String
    let feedName: String
    let playbackID: Int
    let league: League
    let gameDate: String
    let gameTime: Date
    var feedPlaylists: [FeedPlaylist]?
    
    // MARK: - Init
    
    init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League, gameDate: String, gameTime: Date, feedPlaylists: [FeedPlaylist]? = nil) {
        switch feedType {
        case "HOME":
            self.feedType = "Home"
        case "AWAY":
            self.feedType = "Away"
        case "FRENCH":
            self.feedType = "French"
        case "NATIONAL":
            self.feedType = "National"
        default:
            self.feedType = feedType
        }
        
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
        self.gameDate = gameDate
        self.gameTime = gameTime
        self.feedPlaylists = feedPlaylists
    }
}
