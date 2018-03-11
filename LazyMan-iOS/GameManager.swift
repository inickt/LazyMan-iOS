//
//  GameManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Pantomime

protocol GameDataDelegate
{
    func updateGames(nhlGames: [Game]?, mlbGames: [Game]?)
}

class GameManager
{
    static let manager = GameManager()
    
    var delegate: GameDataDelegate?
    
    private var nhlGames = [String : [Game]]()
    private var mlbGames = [String : [Game]]()
    
    private let nhlFormatURL = "https://statsapi.web.nhl.com/api/v1/schedule?date=%@&expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg"
    
    func requestGames(date: String)
    {
        if self.nhlGames[date] != nil //, let mlbGames = self.games.mlbGames[date]
        {
            self.updateDelegate(date: date)
        }
        else
        {
            self.reloadGames(date: date)
        }
    }
    
    func reloadGames(date: String)
    {
        self.getNHLGames(date: date)
    }
    
    func getM3U8(feedURL: URL)
    {
        

        
        
        
    }
    
    private func getNHLGames(date: String)
    {
        let nhlStatsURL = String(format: self.nhlFormatURL, date)
        
        var newGames: [Game] = []
        
        if let url = URL(string: nhlStatsURL)
        {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                let j = try! JSON(data: data!).dictionaryValue
                
                if let numGames = j["totalItems"]?.int
                {
                    if numGames > 0, let dates = j["dates"]?.array
                    {
                        if dates.count > 0, let jsonGames = dates[0].dictionaryValue["games"]?.array
                        {
                            for jsonGame in jsonGames
                            {
                                let homeTeam = TeamManager.nhlTeams[jsonGame["teams"]["home"]["team"]["teamName"].stringValue]
                                let awayTeam = TeamManager.nhlTeams[jsonGame["teams"]["away"]["team"]["teamName"].stringValue]
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                let gameDate = formatter.date(from: jsonGame["gameDate"].stringValue)
                                
                                
                                var gameFeeds = [Feed]()
                                
                                if let jsonMedia = jsonGame["content"]["media"]["epg"].array, jsonMedia.count > 0
                                {
                                    for jsonFeed in jsonMedia[0]["items"].arrayValue
                                    {
                                        if let feedType = jsonFeed["mediaFeedType"].string
                                        {
                                            gameFeeds.append(Feed(feedType: feedType, callLetters: jsonFeed["callLetters"].string, feedName: jsonFeed["feedName"].string, playbackID: jsonFeed["mediaPlaybackId"].intValue, league: League.NHL))
                                        }
                                    }
                                }
                                
                                if let homeTeam = homeTeam, let awayTeam = awayTeam, let gameDate = gameDate {
                                    let gameState: String
                                    
                                    switch jsonGame["status"]["abstractGameState"].stringValue
                                    {
                                    case "Preview":
                                        let timeFormatter = DateFormatter()
                                        timeFormatter.dateFormat = "h:mm a"
                                        gameState = timeFormatter.string(from: gameDate)
                                        break
                                        
                                    case "Live":
                                        gameState = jsonGame["linescore"]["currentPeriodOrdinal"].stringValue + " – " + jsonGame["linescore"]["currentPeriodTimeRemaining"].stringValue
                                        break
                                        
                                    case "Final":
                                        gameState = "Final"
                                        break
                                        
                                    default:
                                        gameState = ""
                                        print("error")
                                        break
                                    }
                                    
                                    newGames.append(Game(homeTeam: homeTeam, awayTeam: awayTeam, startTime: gameDate, gameState: gameState, feeds: gameFeeds))
                                }
                            }
                            self.nhlGames[date] = newGames
                            self.updateDelegate(date: date)
                        }
                    }
                    else
                    {
                        print("error")
                    }
                }
                else {
                    print("error")
                }
            }).resume()
        }
    }
    
    private func getMLBGames(date: Date)
    {
        
    }
    
    private func updateDelegate(date: String)
    {
        DispatchQueue.main.async {
            self.delegate?.updateGames(nhlGames: self.nhlGames[date], mlbGames: nil)
        }
    }
}

