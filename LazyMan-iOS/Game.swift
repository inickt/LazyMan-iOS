//
//  Game.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

enum GameState: Int
{
    case live = 0
    case preview = 1
    case other = 2
    case final = 3
    case postponed = 4
    case tbd = 5
    
    init(abstractState: String, detailedState: String)
    {
        if abstractState.contains("Postponed") || detailedState.contains("Postponed")
        {
            self = .postponed
        }
        else if abstractState.contains("TBD") || detailedState.contains("TBD")
        {
            self = .tbd
        }
        else if abstractState == "Live" || detailedState == "Live"
        {
            self = .live
        }
        else if abstractState == "Preview" || detailedState == "Preview"
        {
            self = .preview
        }
        else if abstractState == "Final" || detailedState == "Final"
        {
            self = .final
        }
        else
        {
            self = .other
        }
    }
}

class Game
{
    let homeTeam: Team
    let awayTeam: Team
    let startTime: Date
    let gameState: GameState
    let liveGameState: String
    let feeds: [Feed]
    
    private let gameTimeFormatter = DateFormatter()
    
    init(homeTeam: Team, awayTeam: Team, startTime: Date, gameState: GameState, liveGameState: String, feeds: [Feed])
    {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.startTime = startTime
        self.gameState = gameState
        self.liveGameState = liveGameState
        self.feeds = feeds
        
        self.gameTimeFormatter.dateFormat = "h:mm a"
    }
    
    func getGameState() -> String
    {
        switch self.gameState
        {
        case .live:
            return self.liveGameState
            
        case .preview:
            return self.gameTimeFormatter.string(from: self.startTime)
            
        case .other:
            return self.liveGameState
            
        case .final:
            return "Final"
            
        case .postponed:
            return "Postponed"
            
        case .tbd:
            return "TBD"
        }
    }
    
    static func sort(game1: Game, game2: Game) -> Bool
    {
        if game1.gameState == .live && game2.gameState == .live
        {
            return game1.startTime <= game2.startTime
        }
        else
        {
            return game1.gameState.rawValue <= game2.gameState.rawValue
        }
    }
}
