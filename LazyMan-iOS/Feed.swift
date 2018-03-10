//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class Feed
{
    private let feedType: String
    private let callLetters: String?
    private let feedName: String?
    private let playbackID: Int
    private let league: League
    
    init(feedType: String, callLetters: String?, feedName: String?, playbackID: Int, league: League)
    {
        self.feedType = feedType
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
    }
    
    func getDisplayName() -> String
    {
        return ""
    }
    
    func getURL(gameDate: Date)
    {
        if Calendar.current.isDateInToday(gameDate)
        {
            
        }
        else
        {
        
        }
    }
}
