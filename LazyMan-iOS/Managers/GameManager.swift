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

protocol GameManagerType {
    func getGames(date: Date, league: League, ignoreCache: Bool, completion: @escaping (Result<[Game], GameManagerError>) -> ())
}

class GameManager: GameManagerType {
    
    // MARK: - Static private properties
    
    static private let nhlFormatURL = "https://statsapi.web.nhl.com/api/v1/schedule?date=%@&expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg"
    static private let mlbFormatURL = "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date=%@&hydrate=team,linescore,game(content(summary,media(epg)))&language=en"
    
    // MARK: - Static public properties
    
    static let manager: GameManagerType = GameManager()
    
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
    
    func getGames(date: Date, league: League, ignoreCache: Bool, completion: @escaping (Result<[Game], GameManagerError>) -> ()) {
        if !ignoreCache {
            switch league {
            case .NHL:
                if let games = self.nhlGames[self.formatter.string(from: date)] {
                    completion(.success(games))
                    return
                }
            case .MLB:
                if let games = self.mlbGames[self.formatter.string(from: date)] {
                    completion(.success(games))
                    return
                }
            }
        }
        else {
            switch league {
            case .NHL:
                self.nhlGames[self.formatter.string(from: date)] = nil
            case .MLB:
                self.mlbGames[self.formatter.string(from: date)] = nil
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            switch self.loadJson(from: league, for: date) {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.jsonError(error.error)))
                }
            case .success(let json):
                let result = self.parseJson(json: json, league: league, date: self.formatter.string(from: date))
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func loadJson(from league: League, for date: Date) -> Result<JSON, StringError>{
        let stringDate = self.formatter.string(from: date)
        
        switch league {
        case .NHL:
            return self.nhlJSONLoader.load(date: stringDate)
        case .MLB:
            return self.mlbJSONLoader.load(date: stringDate)
        }
    }
    
    func parseJson(json: JSON, league: League, date: String) -> Result<[Game], GameManagerError> {

        switch self.getJSONGames(json: json) {
        case .failure(let error):
                return .failure(error)
        case .success(let jsonGames):
            var games: [Game] = []
            switch league {
            case .NHL:
                games = self.nhlJSONtoGames(jsonGames: jsonGames)
                self.nhlGames[date] = games
            case .MLB:
                games = self.mlbJSONtoGames(jsonGames: jsonGames)
                self.mlbGames[date] = games
            }
            
            return .success(games)
        }
    }
    
    private func nhlJSONtoGames(jsonGames: [JSON]) -> [Game] {
        var newGames: [Game] = []
        
        for nhlGame in jsonGames {
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
                                              league: League.NHL))
                    }
                }
                
                let gameState = GameState(abstractState: nhlGame["status"]["abstractGameState"].stringValue, detailedState: nhlGame["status"]["detailedState"].stringValue, startTimeTBD: nhlGame["status"]["startTimeTBD"].boolValue)
                let liveGameState = gameState == .live ? "\(nhlGame["linescore"]["currentPeriodOrdinal"].stringValue) - \(nhlGame["linescore"]["currentPeriodTimeRemaining"].stringValue)" : nhlGame["status"]["detailedState"].stringValue
                
                newGames.appendOptional(Game(homeTeam: homeTeam, awayTeam: awayTeam, startTime: gameDate, gameState: gameState, liveGameState: liveGameState, feeds: gameFeeds))
            }
        }
        
        return newGames
    }
    
    private func mlbJSONtoGames(jsonGames: [JSON]) -> [Game] {
        var newGames: [Game] = []
        
        for mlbGame in jsonGames {
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
                                              league: League.MLB))
                    }
                }
                
                let gameState = GameState(abstractState: mlbGame["status"]["abstractGameState"].stringValue, detailedState: mlbGame["status"]["detailedState"].stringValue, startTimeTBD: mlbGame["status"]["startTimeTBD"].boolValue)
                let liveGameState = gameState == .live ? "\(mlbGame["linescore"]["currentInningOrdinal"].stringValue) - \(mlbGame["linescore"]["inningHalf"].stringValue)" : mlbGame["status"]["detailedState"].stringValue
                
                newGames.appendOptional(Game(homeTeam: homeTeam, awayTeam: awayTeam, startTime: gameDate, gameState: gameState, liveGameState: liveGameState, feeds: gameFeeds))
            }
        }
        
        return newGames
    }
    
    
    // MARK: - Private
    
    private func getJSONGames(json: JSON) -> Result<[JSON], GameManagerError> {
        guard let numGames = json["totalItems"].int, numGames > 0 else {
            return .failure(.noGames)
        }
        
        guard let games = json["dates"][0]["games"].array else {
            return .failure(.jsonError("Error parsing JSON game array data."))
        }
        
        return .success(games)
    }
}

fileprivate extension Array {
    mutating func appendOptional(_ newElement: Element?) {
        if let newElement = newElement {
            self.append(newElement)
        }
    }
}

enum GameManagerError: Error {
    case noGames, jsonError(String), notLoaded
}
