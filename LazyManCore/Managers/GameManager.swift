//
//  GameManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol GameManagerType {
    func getGames(date: Date,
                  league: League,
                  ignoreCache: Bool,
                  completion: @escaping (Result<[Game], GameManagerError>) -> Void)
}

public enum GameManagerError: LazyManError {

    public var messgae: String {
        switch self {
        case .noGames:
            return "There are no games today."
        case .invalid(let type):
            return "Error parsing JSON \(type)."
        case .jsonError(let jsonError):
            return jsonError.messgae
        }
    }

    case noGames, invalid(String), jsonError(JSONLoaderError)
}

public class GameManager: GameManagerType {

    // MARK: - Static private properties

    // swiftlint:disable:next line_length
    public static let nhlFormatURL = "https://statsapi.web.nhl.com/api/v1/schedule?date=%@&expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg"
    // swiftlint:disable:next line_length
    public static let mlbFormatURL = "https://statsapi.mlb.com/api/v1/schedule?sportId=1&date=%@&hydrate=team,linescore,game(content(summary,media(epg)))&language=en"

    // MARK: - Static public properties

    public static let manager: GameManagerType = GameManager()

    // MARK: - Properties

    private var nhlGames = [String: [Game]]()
    private var mlbGames = [String: [Game]]()

    private let nhlJSONLoader: JSONLoader
    private let mlbJSONLoader: JSONLoader
    private let teamManager: TeamManagerType

    // MARK: - Initialization

    // Replace for testing:
    // init(nhlJSONLoader: JSONLoader = JSONFileLoader(filename: "nhlschedule2018-04-05"),
    //      mlbJSONLoader: JSONLoader = JSONFileLoader(filename: "mlbschedule2018-04-05"))
    public init(nhlJSONLoader: JSONLoader = JSONWebLoader(dateFormatURL: nhlFormatURL),
         mlbJSONLoader: JSONLoader = JSONWebLoader(dateFormatURL: mlbFormatURL),
         teamManager: TeamManagerType = TeamManager.shared) {
        self.nhlJSONLoader = nhlJSONLoader
        self.mlbJSONLoader = mlbJSONLoader
        self.teamManager = teamManager
    }

    // MARK: - Public

    public func getGames(date: Date,
                  league: League,
                  ignoreCache: Bool,
                  completion: @escaping (Result<[Game], GameManagerError>) -> Void) {
        if !ignoreCache, let games = self.getGames(date: date, league: league) {
            completion(.success(games))
            return
        }

        self.setGames(date: date, league: league, games: nil)

        DispatchQueue.global(qos: .userInitiated).async {
            switch self.loadJson(from: league, for: date) {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.jsonError(error)))
                }
            case .success(let json):
                let result = self.parseJson(json: json, league: league)
                DispatchQueue.main.async {
                    switch result {
                    case .success(let games):
                        self.setGames(date: date, league: league, games: games)
                        fallthrough
                    default:
                        completion(result)
                    }
                }
            }
        }
    }

    public func loadJson(from league: League, for date: Date) -> Result<JSON, JSONLoaderError> {
        let stringDate = DateUtils.convertToYYYYMMDD(from: date)

        switch league {
        case .NHL:
            return self.nhlJSONLoader.load(date: stringDate)
        case .MLB:
            return self.mlbJSONLoader.load(date: stringDate)
        }
    }

    public func parseJson(json: JSON, league: League) -> Result<[Game], GameManagerError> {

        switch self.getJSONGames(json: json) {
        case .failure(let error):
                return .failure(error)
        case .success(let jsonGames):
            var games: [Game] = []
            switch league {
            case .NHL:
                games = self.nhlJSONtoGames(jsonGames: jsonGames).sorted(by: self.teamManager.compareGames)
            case .MLB:
                games = self.mlbJSONtoGames(jsonGames: jsonGames).sorted(by: self.teamManager.compareGames)
            }

            return .success(games)
        }
    }

    private func nhlJSONtoGames(jsonGames: [JSON]) -> [Game] {
        var newGames: [Game] = []

        for nhlGame in jsonGames {
            if let gameDate = DateUtils.convertGMTtoDate(from: nhlGame["gameDate"].stringValue) {

                let homeTeam = Team(name: nhlGame["teams"]["home"]["team"]["name"].stringValue,
                                    teamName: nhlGame["teams"]["home"]["team"]["teamName"].stringValue,
                                    abbreviation: nhlGame["teams"]["home"]["team"]["abbreviation"].stringValue,
                                    league: .NHL)

                let awayTeam = Team(name: nhlGame["teams"]["away"]["team"]["name"].stringValue,
                                    teamName: nhlGame["teams"]["away"]["team"]["teamName"].stringValue,
                                    abbreviation: nhlGame["teams"]["away"]["team"]["abbreviation"].stringValue,
                                    league: .NHL)

                var gameFeeds = [Feed]()
                if let mediaFeeds = nhlGame["content"]["media"]["epg"].array, !mediaFeeds.isEmpty {
                    for mediaType in mediaFeeds {
                        if mediaType["title"].stringValue == "NHLTV" {
                            for mediaFeed in mediaType["items"].arrayValue {
                                gameFeeds.append(Feed(feedType: mediaFeed["mediaFeedType"].stringValue,
                                                      callLetters: mediaFeed["callLetters"].stringValue,
                                                      feedName: mediaFeed["feedName"].stringValue,
                                                      playbackID: mediaFeed["mediaPlaybackId"].intValue,
                                                      league: League.NHL,
                                                      date: gameDate))
                            }
                        }

                        if mediaType["title"].stringValue == "Extended Highlights",
                            let playback = mediaType["items"][0]["playbacks"].arrayValue.first(where: { $0["name"] == "HTTP_CLOUD_TABLET_60"}),
                            let url = URL(string: playback["url"].stringValue) {
                            gameFeeds.append(Feed(highlightName: "Extended Highlights", league: .NHL, url: url))
                        }
                        if mediaType["title"].stringValue == "Recap",
                            let playback = mediaType["items"][0]["playbacks"].arrayValue.first(where: { $0["name"] == "HTTP_CLOUD_TABLET_60"}),
                            let url = URL(string: playback["url"].stringValue) {
                            gameFeeds.append(Feed(highlightName: "Recap", league: .NHL, url: url))
                        }
                    }
                }

                let gameState = GameState(abstractState: nhlGame["status"]["abstractGameState"].stringValue,
                                          detailedState: nhlGame["status"]["detailedState"].stringValue,
                                          startTimeTBD: nhlGame["status"]["startTimeTBD"].boolValue)
                // swiftlint:disable:next line_length
                let liveGameState = gameState == .live ? "\(nhlGame["linescore"]["currentPeriodOrdinal"].stringValue) - \(nhlGame["linescore"]["currentPeriodTimeRemaining"].stringValue)" : nhlGame["status"]["detailedState"].stringValue

                var homeTeamScore: Int?
                var awayTeamScore: Int?
                if [.live, .final].contains(gameState) {
                    homeTeamScore = nhlGame["teams"]["home"]["score"].int
                    awayTeamScore = nhlGame["teams"]["away"]["score"].int
                }

                newGames.appendOptional(Game(homeTeam: homeTeam,
                                             awayTeam: awayTeam,
                                             startTime: gameDate,
                                             gameState: gameState,
                                             liveGameState: liveGameState,
                                             homeTeamScore: homeTeamScore,
                                             awayTeamScore: awayTeamScore,
                                             feeds: gameFeeds))
            }
        }

        return newGames
    }

    private func mlbJSONtoGames(jsonGames: [JSON]) -> [Game] {
        var newGames: [Game] = []

        for mlbGame in jsonGames {
            if let gameDate = DateUtils.convertGMTtoDate(from: mlbGame["gameDate"].stringValue) {

                let homeTeam = Team(name: mlbGame["teams"]["home"]["team"]["name"].stringValue,
                                    teamName: mlbGame["teams"]["home"]["team"]["teamName"].stringValue,
                                    abbreviation: mlbGame["teams"]["home"]["team"]["abbreviation"].stringValue,
                                    league: .MLB)

                let awayTeam = Team(name: mlbGame["teams"]["away"]["team"]["name"].stringValue,
                                    teamName: mlbGame["teams"]["away"]["team"]["teamName"].stringValue,
                                    abbreviation: mlbGame["teams"]["away"]["team"]["abbreviation"].stringValue,
                                    league: .MLB)

                var gameFeeds = [Feed]()
                if let mediaFeeds = mlbGame["content"]["media"]["epg"].array, !mediaFeeds.isEmpty {
                    for mediaFeed in mediaFeeds[0]["items"].arrayValue {
                        if mediaFeed["mediaFeedType"].stringValue.contains("IN_") {
                            continue
                        }
                        gameFeeds.append(Feed(feedType: mediaFeed["mediaFeedType"].stringValue,
                                              callLetters: mediaFeed["callLetters"].stringValue,
                                              feedName: mediaFeed["feedName"].stringValue,
                                              playbackID: mediaFeed["id"].intValue,
                                              league: League.MLB,
                                              date: gameDate))
                    }
                }

                let gameState = GameState(abstractState: mlbGame["status"]["abstractGameState"].stringValue,
                                          detailedState: mlbGame["status"]["detailedState"].stringValue,
                                          startTimeTBD: mlbGame["status"]["startTimeTBD"].boolValue)
                // swiftlint:disable:next line_length
                let liveGameState = gameState == .live ? "\(mlbGame["linescore"]["currentInningOrdinal"].stringValue) - \(mlbGame["linescore"]["inningHalf"].stringValue)" : mlbGame["status"]["detailedState"].stringValue

                var homeTeamScore: Int?
                var awayTeamScore: Int?
                if [.live, .final].contains(gameState) {
                    homeTeamScore = mlbGame["teams"]["home"]["score"].int
                    awayTeamScore = mlbGame["teams"]["away"]["score"].int
                }

                newGames.appendOptional(Game(homeTeam: homeTeam,
                                             awayTeam: awayTeam,
                                             startTime: gameDate,
                                             gameState: gameState,
                                             liveGameState: liveGameState,
                                             homeTeamScore: homeTeamScore,
                                             awayTeamScore: awayTeamScore,
                                             feeds: gameFeeds))
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
            return .failure(.invalid("game array data"))
        }

        return .success(games)
    }

    private func getGames(date: Date, league: League) -> [Game]? {
        switch league {
        case .NHL:
            return self.nhlGames[DateUtils.convertToYYYYMMDD(from: date)]
        case .MLB:
            return self.mlbGames[DateUtils.convertToYYYYMMDD(from: date)]
        }
    }

    private func setGames(date: Date, league: League, games: [Game]?) {
        switch league {
        case .NHL:
            self.nhlGames[DateUtils.convertToYYYYMMDD(from: date)] = games
        case .MLB:
            self.mlbGames[DateUtils.convertToYYYYMMDD(from: date)] = games
        }
    }
}

fileprivate extension Array {
    mutating func appendOptional(_ newElement: Element?) {
        if let newElement = newElement {
            self.append(newElement)
        }
    }
}
