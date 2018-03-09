//
//  Game.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class Game
{
    let homeTeam: Team
    let awayTeam: Team
    let startTime: Date
    let gameState: String
    let feeds: [Feed]
    
    init(homeTeam: Team, awayTeam: Team, startTime: Date, gameState: String, feeds: [Feed])
    {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.startTime = startTime
        self.gameState = gameState
        self.feeds = feeds
    }
    
}

class Feed
{
    private let feedType: String
    private let callLetters: String?
    private let feedName: String?
    private let playbackID: Int
    
    init(feedType: String, callLetters: String?, feedName: String?, playbackID: Int)
    {
        self.feedType = feedType
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
    }
    
    func getDisplayName() -> String
    {
        return ""
    }
    
    func getURL()
    {
        
    }
}
