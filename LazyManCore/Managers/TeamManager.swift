//
//  TeamManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public protocol TeamManagerType {
    var nhlTeams: [String: Team] { get }
    var mlbTeams: [String: Team] { get }

    func isFavorite(team: Team) -> Bool
    func hasFavoriteTeam(game: Game) -> Bool
    func getDefaultFeed(game: Game) -> Feed?
    func compareGames(lhs: Game, rhs: Game) -> Bool
}

public final class TeamManager: TeamManagerType {

    // MARK: - Shared Manager

    public static let shared: TeamManagerType = TeamManager()

    // MARK: - Public Properties

    public lazy var nhlTeams: [String: Team] = {
        var teams = [String: Team]()
        for team in self.loadTeams(league: .NHL) {
            teams[team.teamName] = team
        }
        return teams
    }()

    public lazy var mlbTeams: [String: Team] = {
        var teams = [String: Team]()
        for team in self.loadTeams(league: .MLB) {
            teams[team.teamName] = team
        }
        return teams
    }()

    // MARK: - Private Properties

    private let settingsManager: SettingsManagerType

    // MARK: Init

    public init(settingsManager: SettingsManagerType = SettingsManager.shared) {
        self.settingsManager = settingsManager
    }

    // MARK: - Public

    public func isFavorite(team: Team) -> Bool {
        return self.settingsManager.favoriteMLBTeams.contains(team) ||
            self.settingsManager.favoriteNHLTeams.contains(team)
    }

    public func hasFavoriteTeam(game: Game) -> Bool {
        return self.isFavorite(team: game.awayTeam) || self.isFavorite(team: game.homeTeam)
    }

    public func getDefaultFeed(game: Game) -> Feed? {
        if self.settingsManager.preferFrench, let feed = game.feeds.first(where: { $0.feedType == .french }) {
            return feed
        } else if self.isFavorite(team: game.homeTeam), let feed = game.feeds.first(where: { $0.feedType == .home }) {
            return feed
        } else if self.isFavorite(team: game.awayTeam), let feed = game.feeds.first(where: { $0.feedType == .away }) {
            return feed
        } else {
            return game.feeds.first
        }
    }

    public func compareGames(lhs: Game, rhs: Game) -> Bool {
        if self.hasFavoriteTeam(game: lhs) != self.hasFavoriteTeam(game: rhs) {
            return self.hasFavoriteTeam(game: lhs)
        } else if (lhs.gameState == .live && rhs.gameState == .live)
            || (lhs.gameState == .preview && rhs.gameState == .preview) {
            return lhs.startTime < rhs.startTime
        } else {
            return lhs.gameState.rawValue < rhs.gameState.rawValue
        }
    }

    // MARK: - Private

    private func loadTeams(league: League) -> [Team] {
        let decoder = PropertyListDecoder()
        guard let teamsPlistUrl = frameworkBundle?.url(forResource: "\(league)Teams", withExtension: "plist"),
            let data = try? Data(contentsOf: teamsPlistUrl),
            let teams = try? decoder.decode([Team].self, from: data) else {
                return []
        }
        return teams
    }
}
