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
    
    func getGames(from startDate: Date,
                  to endDate: Date,
                  league: League,
                  ignoreCache: Bool,
                  completion: @escaping (Result<[Game], GameManagerError>) -> Void)
}

//extension GameManagerType {
//    func getGames(date: Date,
//                  league: League,
//                  ignoreCache: Bool,
//                  completion: @escaping (Result<[Game], GameManagerError>) -> Void) {
//        self.getGames(from: date, to: date, league: league, ignoreCache: ignoreCache, completion: completion)
//    }
//}

public enum GameManagerError: LazyManError {

    public var messgae: String {
        switch self {
        case .noGames:
            return "There are no games today."
        case .invalid(let type):
            return "Error parsing JSON \(type)."
        case .loadError(let error):
            return error.messgae
        }
    }

    case noGames, invalid(String), loadError(ScheduleLoaderError)
}

public class GameManager: GameManagerType {

    // MARK: - Static public properties

    public static let manager: GameManagerType = GameManager()

    // MARK: - Properties

    private var nhlGames = [String : [Game]]()
    private var mlbGames = [String : [Game]]()
    private let scheduleLoader: ScheduleLoader

    // MARK: - Initialization

    public init(scheduleLoader: ScheduleLoader = ScheduleWebLoader()) {
        self.scheduleLoader = scheduleLoader
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
            switch self.scheduleLoader.load(league: league, date: date) {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.loadError(error)))
                }
            case .success(let data):
                // TODO: errors
                let allGames = try! league.scheduleResponse(for: data).games
                let stringDate = DateUtils.convertToYYYYMMDD(from: date)
                
                DispatchQueue.main.async {
//                    if let allGames = allGames, let games = allGames[stringDate] {
                    if let games = allGames[stringDate] {
                        allGames.forEach { (key: String, value: [Game]) in
                            self.setGames(date: key, league: league, games: value)
                        }
                        completion(.success(games))
                    } else {
                        completion(.failure(.invalid("")))
                    }
                }
            }
        }
    }
    
    public func getGames(from startDate: Date,
                         to endDate: Date,
                         league: League,
                         ignoreCache: Bool,
                         completion: @escaping (Result<[Game], GameManagerError>) -> Void) {
//        if !ignoreCache, let games = self.getGames(date: date, league: league) {
//            completion(.success(games))
//            return
//        }

//        self.setGames(date: date, league: league, games: nil)

        DispatchQueue.global(qos: .userInitiated).async {
            switch self.scheduleLoader.load(league: league, from: startDate, to: endDate) {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.loadError(error)))
                }
            case .success(let data):
                // TODO: errors
                let allGames = try! league.scheduleResponse(for: data).games

                DispatchQueue.main.async {
//                    if let allGames = allGames {
                        allGames.forEach { (key: String, value: [Game]) in
                            self.setGames(date: key, league: league, games: value)
                        }
                        completion(.success(allGames.values.flatMap { $0 }))
//                    } else {
//                        completion(.failure(.invalid("")))
//                    }
                }
            }
        }
    }

    // MARK: - Private

    private func getGames(from startDate: Date, to endDate: Date, league: League) -> [Game]? {
        var currentDate = startDate
        var games = [Game]()
        
        while currentDate <= endDate {
            if let newGames = self.getGames(date: currentDate, league: league) {
                games.append(contentsOf: newGames)
            }
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }

        return games
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
        self.setGames(date: DateUtils.convertToYYYYMMDD(from: date), league: league, games: games)
    }
    
    private func setGames(date: String, league: League, games: [Game]?) {
        switch league {
        case .NHL:
            self.nhlGames[date] = games
        case .MLB:
            self.mlbGames[date] = games
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
