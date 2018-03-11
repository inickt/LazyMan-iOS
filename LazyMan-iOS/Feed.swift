//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

enum CDN: String
{
    case Level3 = "l3c", Akamai = "akc"
}

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
}
