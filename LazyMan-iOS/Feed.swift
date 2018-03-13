//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit


protocol GameOptionCellText
{
    func getTitle() -> String
    func getDetail() -> String
}


enum CDN: String, GameOptionCellText
{
    case Level3 = "l3c", Akamai = "akc"
    
    func getTitle() -> String
    {
        switch self
        {
        case .Level3:
            return "Level 3"
        case .Akamai:
            return "Akamai"
        }
    }
    
    func getDetail() -> String
    {
        return ""
    }
}

class Feed: GameOptionCellText
{
    private let feedType: String
    private let callLetters: String
    private let feedName: String
    private let playbackID: Int
    private let league: League
    
    init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League)
    {
        self.feedType = feedType
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
    }
    
    func getURL(gameDate: Date, cdn: CDN) -> URL?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let baseFeedURLString = "http://nhl.freegamez.ga/m3u8/" + formatter.string(from: gameDate) + "/"
        
        switch self.league {
        case .NHL:
            
            if Calendar.current.isDateInToday(gameDate)
            {
                do
                {
                    let s = try String(contentsOf: URL(string: baseFeedURLString + String(self.playbackID) + cdn.rawValue)!)
                    return URL(string: s)

                }
                catch
                {
                    return URL(string: "")
                }
            }
            else
            {
                return URL(string: baseFeedURLString + String(self.playbackID))
            }
        case .MLB:
            return URL(string: "")
        }
    }
    
    func getTitle() -> String
    {
        if self.feedName != ""
        {
            return feedName
        }
        else
        {
            if self.callLetters != ""
            {
                return String(format: "%@ (%@)", self.feedType, callLetters)
            }
            else
            {
                return self.feedType
            }
        }
    }
    
    func getDetail() -> String
    {
        return ""
    }
}
