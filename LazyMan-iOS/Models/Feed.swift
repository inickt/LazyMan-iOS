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
    
    let feedType: FeedType
    let callLetters: String
    let feedName: String
    let playbackID: Int
    let league: League
    var feedPlaylists: [FeedPlaylist]?
    
    // MARK: - Init
    
    init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League, feedPlaylists: [FeedPlaylist]? = nil) {
        self.feedType = FeedType(feedType: feedType)
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
        self.feedPlaylists = feedPlaylists
    }
}

enum FeedType {
    case home, away, french, national, other(String)
    
    init(feedType: String) {
        switch feedType {
        case "HOME":
            self = .home
        case "AWAY":
            self = .away
        case "FRENCH":
            self = .french
        case "NATIONAL":
            self = .national
        default:
            self = .other(feedType)
        }
    }
}
