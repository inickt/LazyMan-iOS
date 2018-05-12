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

class GameManager
{
    // MARK: - Static private properties
    
    static private let nhlFormatURL = "https://statsapi.web.nhl.com/api/v1/schedule?date=%@&expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg"
    static private let mlbFormatURL = "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date=%@&hydrate=team,linescore,game(content(summary,media(epg)))&language=en"
    
    // MARK: - Static public properties
    
    static let manager = GameManager()
    
    // Mark: - Properties
    
    private var nhlGames = [String : [Game]]()
    private var mlbGames = [String : [Game]]()
    
    private let formatter = DateFormatter()
    private let gmtFormatter = DateFormatter()
    
    private let nhlJSONLoader: JSONLoader
    private let mlbJSONLoader: JSONLoader
    
    // MARK: - Initialization
    
    // Replace for testing:
    // init(nhlJSONLoader: JSONLoader = JSONFileLoader(filename: "nhlschedule2018-04-05"),
    //      mlbJSONLoader: JSONLoader = JSONFileLoader(filename: "mlbschedule2018-04-05"))
    init(nhlJSONLoader: JSONLoader = JSONWebLoader(dateFormatURL: nhlFormatURL),
         mlbJSONLoader: JSONLoader = JSONWebLoader(dateFormatURL: mlbFormatURL))
    {
        self.nhlJSONLoader = nhlJSONLoader
        self.mlbJSONLoader = mlbJSONLoader
        
        self.formatter.dateFormat = "yyyy-MM-dd"
        
        self.gmtFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.gmtFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.gmtFormatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    // MARK: - Public
    
    func getGames(date: Date, league: League) -> [Game]?
    {
        switch league
        {
        case .NHL:
            return self.nhlGames[self.formatter.string(from: date)]
            
        case .MLB:
            return self.mlbGames[self.formatter.string(from: date)]
        }
    }
    
    func reloadGames(date: Date, league: League, completion: (([Game]) -> ())?, error: @escaping ((String) -> ()))
    {
        switch league
        {
        case .NHL:
            self.getNHLGames(date: self.formatter.string(from: date), completion: completion, errorCompletion: error)
            
        case .MLB:
            self.getMLBGames(date: self.formatter.string(from: date), completion: completion, errorCompletion: error)
        }
    }
    
    // MARK: - Private
    
    private func getNHLGames(date: String, completion: (([Game]) -> ())?, errorCompletion: @escaping ((String) -> ()))
    {
        DispatchQueue.global(qos: .utility).async {
            self.nhlJSONLoader.load(date: date, completion: { (jsonData) in
                var newGames: [Game] = []
                
                self.getJSONGames(data: jsonData, completion: { (nhlGames) in
                    for nhlGame in nhlGames
                    {
                        if let gameDate = self.gmtFormatter.date(from: nhlGame["gameDate"].stringValue),
                            let homeTeam = TeamManager.nhlTeams[nhlGame["teams"]["home"]["team"]["teamName"].stringValue],
                            let awayTeam = TeamManager.nhlTeams[nhlGame["teams"]["away"]["team"]["teamName"].stringValue]
                        {
                            var gameFeeds = [Feed]()
                            if let mediaFeeds = nhlGame["content"]["media"]["epg"].array, mediaFeeds.count > 0
                            {
                                for mediaFeed in mediaFeeds[0]["items"].arrayValue
                                {
                                    gameFeeds.append(Feed(feedType: mediaFeed["mediaFeedType"].stringValue,
                                                          callLetters: mediaFeed["callLetters"].stringValue,
                                                          feedName: mediaFeed["feedName"].stringValue,
                                                          playbackID: mediaFeed["mediaPlaybackId"].intValue,
                                                          league: League.NHL,
                                                          gameDate: date,
                                                          gameTime: gameDate))
                                }
                            }
                            
                            let gameState = GameState(abstractState: nhlGame["status"]["abstractGameState"].stringValue, detailedState: nhlGame["status"]["detailedState"].stringValue, startTimeTBD: nhlGame["status"]["startTimeTBD"].boolValue)
                            let liveGameState = gameState == .live ? "\(nhlGame["linescore"]["currentPeriodOrdinal"].stringValue) - \(nhlGame["linescore"]["currentPeriodTimeRemaining"].stringValue)" : nhlGame["status"]["detailedState"].stringValue
                            
                            newGames.append(Game(homeTeam: homeTeam, awayTeam: awayTeam, startTime: gameDate, gameState: gameState, liveGameState: liveGameState, feeds: gameFeeds))
                        }
                    }
                    
                    guard newGames.count > 0 else
                    {
                        DispatchQueue.main.async {
                            errorCompletion("There are no games today.")
                        }
                        return
                    }
                    
                    newGames.sort(by: Game.sort)
                    
                    self.nhlGames[date] = newGames
                    DispatchQueue.main.async {
                        completion?(newGames)
                    }
                }, errorCompletion: errorCompletion)
            }, error: { (error) in
                DispatchQueue.main.async {
                    errorCompletion(error)
                }
            })
        }
    }
    
    private func getMLBGames(date: String, completion: (([Game]) -> ())?, errorCompletion: @escaping ((String) -> ()))
    {
        DispatchQueue.global(qos: .utility).async {
            self.mlbJSONLoader.load(date: date, completion: { (jsonData) in
                var newGames: [Game] = []
                
                self.getJSONGames(data: jsonData, completion: { (mlbGames) in
                    for mlbGame in mlbGames
                    {
                        if let gameDate = self.gmtFormatter.date(from: mlbGame["gameDate"].stringValue),
                            let homeTeam = TeamManager.mlbTeams[mlbGame["teams"]["home"]["team"]["teamName"].stringValue],
                            let awayTeam = TeamManager.mlbTeams[mlbGame["teams"]["away"]["team"]["teamName"].stringValue]
                        {
                            var gameFeeds = [Feed]()
                            if let mediaFeeds = mlbGame["content"]["media"]["epg"].array, mediaFeeds.count > 0
                            {
                                for mediaFeed in mediaFeeds[0]["items"].arrayValue
                                {
                                    if mediaFeed["mediaFeedType"].stringValue.contains("IN_")
                                    {
                                        continue
                                    }
                                    
                                    gameFeeds.append(Feed(feedType: mediaFeed["mediaFeedType"].stringValue,
                                                          callLetters: mediaFeed["callLetters"].stringValue,
                                                          feedName: mediaFeed["feedName"].stringValue,
                                                          playbackID: mediaFeed["id"].intValue,
                                                          league: League.MLB,
                                                          gameDate: date,
                                                          gameTime: gameDate))
                                }
                            }
                            
                            let gameState = GameState(abstractState: mlbGame["status"]["abstractGameState"].stringValue, detailedState: mlbGame["status"]["detailedState"].stringValue, startTimeTBD: mlbGame["status"]["startTimeTBD"].boolValue)
                            let liveGameState = gameState == .live ? "\(mlbGame["linescore"]["currentInningOrdinal"].stringValue) - \(mlbGame["linescore"]["inningHalf"].stringValue)" : mlbGame["status"]["detailedState"].stringValue
                            
                            newGames.append(Game(homeTeam: homeTeam, awayTeam: awayTeam, startTime: gameDate, gameState: gameState, liveGameState: liveGameState, feeds: gameFeeds))
                        }
                    }
                    
                    guard newGames.count > 0 else
                    {
                        DispatchQueue.main.async {
                            errorCompletion("There are no games today.")
                        }
                        return
                    }
                    
                    newGames.sort(by: Game.sort)
                    
                    self.mlbGames[date] = newGames
                    DispatchQueue.main.async {
                        completion?(newGames)
                    }
                }, errorCompletion: errorCompletion)
            }, error: { (error) in
                DispatchQueue.main.async {
                    errorCompletion(error)
                }
            })
        }
    }
    
    private func getJSONGames(data: Data, completion: ([JSON]) -> (), errorCompletion: @escaping ((String) -> ()))
    {
        guard let json = try? JSON(data: data).dictionaryValue else
        {
            DispatchQueue.main.async {
                errorCompletion("Error parsing JSON data.")
            }
            return
        }
        
        guard let numGames = json["totalItems"]?.int, numGames > 0 else
        {
            DispatchQueue.main.async {
                errorCompletion("There are no games today.")
            }
            return
        }
        
        guard let games = json["dates"]?[0]["games"].array else
        {
            DispatchQueue.main.async {
                errorCompletion("Error parsing JSON game array data.")
            }
            return
        }
        
        completion(games)
    }
}
