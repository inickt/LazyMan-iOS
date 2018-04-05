//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import Pantomime

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
    private let gameDate: String
    private var feedPlaylists: [FeedPlaylist]?
    
    init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League, gameDate: String)
    {
        self.feedType = feedType
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
        self.gameDate = gameDate
    }
    
    func getMasterURL(cdn: CDN) -> URL?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let baseFeedURLString = "http://nhl.freegamez.ga/m3u8/" + self.gameDate + "/"
        
        switch self.league {
        case .NHL:
            do
            {
                let s = try String(contentsOf: URL(string: baseFeedURLString + String(self.playbackID) + cdn.rawValue)!)
                return URL(string: s)
            }
            catch
            {
                do
                {
                    let s = try String(contentsOf: URL(string: baseFeedURLString + String(self.playbackID))!)
                    return URL(string: s)
                }
                catch
                {
                    return nil
                }
            }
        case .MLB:
            return nil
        }
    }
    
    func getFeedPlaylists(cdn: CDN, completion: @escaping ([FeedPlaylist]) -> (), error: @escaping (Error) -> ())
    {
        if let feedPlaylists = self.feedPlaylists
        {
            completion(feedPlaylists)
        }
        else
        {
            var playlists = [FeedPlaylist]()
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let masterURL = self.getMasterURL(cdn: cdn)
                {
                    playlists.append(FeedPlaylist(url: masterURL, quality: "Auto", bandwidth: nil, framerate: nil))
                    
                    let masterPlaylist = ManifestBuilder().parse(masterURL)
                    
                    
                    for index in 0..<masterPlaylist.getPlaylistCount()
                    {
                        if let mediaPlaylist = masterPlaylist.getPlaylist(index),
                            let mediaPath = mediaPlaylist.path,
                            let mediaURL = masterURL.URLByReplacingLastPathComponent(mediaPath)
                        {
                            
                            var framerate: Int?
                            
                            if let mpFramerate = mediaPlaylist.framerate
                            {
                                framerate = Int(mpFramerate.rounded())
                            }
                            
                            playlists.append(FeedPlaylist(url: mediaURL,
                                                          quality: mediaPlaylist.resolution ?? "Unknown",
                                                          bandwidth: mediaPlaylist.bandwidth,
                                                          framerate: framerate))
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        playlists.sort(by: { (feed1, feed2) -> Bool in
                            
                            let f1b = feed1.getBandwidth() ?? Int.max
                            let f2b = feed2.getBandwidth() ?? Int.max
                            
                            return f1b > f2b
                        })
                        self.feedPlaylists = playlists
                        completion(playlists)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        
                    }
                }
            }

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
