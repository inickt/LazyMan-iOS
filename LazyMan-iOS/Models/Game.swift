//
//  Game.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

enum GameState: Int {

    case live, preview, other, final, postponed, tbd

    init(abstractState: String, detailedState: String, startTimeTBD: Bool) {
        let states = [abstractState, detailedState]

        if states.contains(where: { $0.contains("Postponed") }) {
            self = .postponed
        } else if states.contains(where: { $0.contains("TBD") }) || startTimeTBD {
            self = .tbd
        } else if states.contains(where: { $0.contains("Live") }) {
            self = .live
        } else if states.contains(where: { $0.contains("Preview") }) {
            self = .preview
        } else if states.contains(where: { $0.contains("Final") }) {
            self = .final
        } else {
            self = .other
        }
    }
}

class Game {

    // MARK: - Static

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    // MARK: - Properties

    let homeTeam: Team
    let awayTeam: Team
    let startTime: Date
    let gameState: GameState
    let liveGameState: String
    let feeds: [Feed]
    var gameStateDescription: String {
        switch self.gameState {
        case .live:
            return self.liveGameState
        case .preview:
            return Game.timeFormatter.string(from: self.startTime)
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
    let league: League

    // MARK: - Init

    init?(homeTeam: Team, awayTeam: Team, startTime: Date, gameState: GameState, liveGameState: String, feeds: [Feed]) {
        guard homeTeam.league == awayTeam.league else {
            return nil
        }

        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.startTime = startTime
        self.gameState = gameState
        self.liveGameState = liveGameState
        self.feeds = feeds
        self.league = homeTeam.league
    }
}

extension Game: Equatable {

    // MARK: - Equarable

    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.awayTeam == rhs.awayTeam && lhs.homeTeam == rhs.homeTeam && lhs.startTime == rhs.startTime
    }
}
