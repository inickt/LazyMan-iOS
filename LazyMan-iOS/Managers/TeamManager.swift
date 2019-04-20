//
//  TeamManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/7/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol TeamManagerType {
    var nhlTeams: [String: Team] { get }
    var mlbTeams: [String: Team] { get }

    func isFavorite(team: Team) -> Bool
    func hasFavoriteTeam(game: Game) -> Bool
    func getDefaultFeed(game: Game) -> Feed?
    func compareGames(lhs: Game, rhs: Game) -> Bool
}

final class TeamManager: TeamManagerType {

    // MARK: - Shared Manager

    static let shared = TeamManager()

    // MARK: Initialization

    init(settingsManager: SettingsManagerType = SettingsManager.shared) {
        self.settingsManager = settingsManager
        self.initNHLTeams()
        self.initMLBTeams()
    }

    // MARK: - Private Properties

    private let settingsManager: SettingsManagerType
    var nhlTeams: [String: Team] {
        return self._nhlTeams
    }
    var mlbTeams: [String: Team] {
        return self._mlbTeams
    }

    func isFavorite(team: Team) -> Bool {
        return self.settingsManager.favoriteMLBTeams.contains(team) ||
            self.settingsManager.favoriteNHLTeams.contains(team)
    }

    func hasFavoriteTeam(game: Game) -> Bool {
        return self.isFavorite(team: game.awayTeam) || self.isFavorite(team: game.homeTeam)
    }

    func getDefaultFeed(game: Game) -> Feed? {
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

    func compareGames(lhs: Game, rhs: Game) -> Bool {
        if self.hasFavoriteTeam(game: lhs) != self.hasFavoriteTeam(game: rhs) {
            return self.hasFavoriteTeam(game: lhs)
        } else if (lhs.gameState == .live && rhs.gameState == .live)
            || (lhs.gameState == .preview && rhs.gameState == .preview) {
            return lhs.startTime < rhs.startTime
        } else {
            return lhs.gameState.rawValue < rhs.gameState.rawValue
        }
    }

    private var _nhlTeams = [String: Team]()
    private var _mlbTeams = [String: Team]()

    // TODO: Move into plist
    // swiftlint:disable comma
    private func initNHLTeams() {
        self.addNHLTeam(loc: "Colorado",     name: "Avalanche",      abbrv: "COL", logo: #imageLiteral(resourceName: "avalanche"))
        self.addNHLTeam(loc: "Chicago",      name: "Blackhawks",     abbrv: "CHI", logo: #imageLiteral(resourceName: "blackhawks"))
        self.addNHLTeam(loc: "Columbus",     name: "Blue Jackets",   abbrv: "CBJ", logo: #imageLiteral(resourceName: "blue-jackets"))
        self.addNHLTeam(loc: "St. Louis",    name: "Blues",          abbrv: "STL", logo: #imageLiteral(resourceName: "blues"))
        self.addNHLTeam(loc: "Boston",       name: "Bruins",         abbrv: "BOS", logo: #imageLiteral(resourceName: "bruins"))
        self.addNHLTeam(loc: "Montreal",     name: "Canadiens",      abbrv: "MTL", logo: #imageLiteral(resourceName: "canadiens"))
        self.addNHLTeam(loc: "Vancouver",    name: "Canucks",        abbrv: "VAN", logo: #imageLiteral(resourceName: "canucks"))
        self.addNHLTeam(loc: "Washington",   name: "Capitals",       abbrv: "WSH", logo: #imageLiteral(resourceName: "capitals"))
        self.addNHLTeam(loc: "Arizona",      name: "Coyotes",        abbrv: "ARI", logo: #imageLiteral(resourceName: "coyotes"))
        self.addNHLTeam(loc: "New Jersey",   name: "Devils",         abbrv: "NJD", logo: #imageLiteral(resourceName: "devils"))
        self.addNHLTeam(loc: "Anaheim",      name: "Ducks",          abbrv: "ANA", logo: #imageLiteral(resourceName: "ducks"))
        self.addNHLTeam(loc: "Calgary",      name: "Flames",         abbrv: "CGY", logo: #imageLiteral(resourceName: "flames"))
        self.addNHLTeam(loc: "Philadelphia", name: "Flyers",         abbrv: "PHI", logo: #imageLiteral(resourceName: "flyers"))
        self.addNHLTeam(loc: "Vegas",        name: "Golden Knights", abbrv: "VGK", logo: #imageLiteral(resourceName: "golden-knights"))
        self.addNHLTeam(loc: "Carolina",     name: "Hurricanes",     abbrv: "CAR", logo: #imageLiteral(resourceName: "hurricanes"))
        self.addNHLTeam(loc: "New York",     name: "Islanders",      abbrv: "NYI", logo: #imageLiteral(resourceName: "islanders"))
        self.addNHLTeam(loc: "Winnipeg",     name: "Jets",           abbrv: "WPG", logo: #imageLiteral(resourceName: "jets"))
        self.addNHLTeam(loc: "Los Angeles",  name: "Kings",          abbrv: "LAK", logo: #imageLiteral(resourceName: "kings"))
        self.addNHLTeam(loc: "Tampa Bay",    name: "Lightning",      abbrv: "TBL", logo: #imageLiteral(resourceName: "lightning"))
        self.addNHLTeam(loc: "Toronto",      name: "Maple Leafs",    abbrv: "TOR", logo: #imageLiteral(resourceName: "maple-leafs"))
        self.addNHLTeam(loc: "Edmonton",     name: "Oilers",         abbrv: "EDM", logo: #imageLiteral(resourceName: "oilers"))
        self.addNHLTeam(loc: "Florida",      name: "Panthers",       abbrv: "FLA", logo: #imageLiteral(resourceName: "panthers"))
        self.addNHLTeam(loc: "Pittsburgh",   name: "Penguins",       abbrv: "PIT", logo: #imageLiteral(resourceName: "penguins"))
        self.addNHLTeam(loc: "Nashville",    name: "Predators",      abbrv: "NSH", logo: #imageLiteral(resourceName: "predators"))
        self.addNHLTeam(loc: "New York",     name: "Rangers",        abbrv: "NYR", logo: #imageLiteral(resourceName: "rangers-NHL"))
        self.addNHLTeam(loc: "Detroit",      name: "Red Wings",      abbrv: "DET", logo: #imageLiteral(resourceName: "red-wings"))
        self.addNHLTeam(loc: "Buffalo",      name: "Sabres",         abbrv: "BUF", logo: #imageLiteral(resourceName: "sabres"))
        self.addNHLTeam(loc: "Ottawa",       name: "Senators",       abbrv: "OTT", logo: #imageLiteral(resourceName: "senators"))
        self.addNHLTeam(loc: "San Jose",     name: "Sharks",         abbrv: "SJS", logo: #imageLiteral(resourceName: "sharks"))
        self.addNHLTeam(loc: "Dallas",       name: "Stars",          abbrv: "DAL", logo: #imageLiteral(resourceName: "stars"))
        self.addNHLTeam(loc: "Minnesota",    name: "Wild",           abbrv: "MIN", logo: #imageLiteral(resourceName: "wild"))
    }

    private func initMLBTeams() {
        self.addMLBTeam(loc: "Los Angeles",   name: "Angels",       abbrv: "LAA", logo: #imageLiteral(resourceName: "angeles"))
        self.addMLBTeam(loc: "Houston",       name: "Astros",       abbrv: "HOU", logo: #imageLiteral(resourceName: "astros"))
        self.addMLBTeam(loc: "Oakland",       name: "Athletics",    abbrv: "OAK", logo: #imageLiteral(resourceName: "athletics"))
        self.addMLBTeam(loc: "Toronto",       name: "Blue Jays",    abbrv: "TOR", logo: #imageLiteral(resourceName: "blue-jays"))
        self.addMLBTeam(loc: "Atlanta",       name: "Braves",       abbrv: "ATL", logo: #imageLiteral(resourceName: "braves"))
        self.addMLBTeam(loc: "Milwaukee",     name: "Brewers",      abbrv: "MIL", logo: #imageLiteral(resourceName: "brewers"))
        self.addMLBTeam(loc: "St. Louis",     name: "Cardinals",    abbrv: "STL", logo: #imageLiteral(resourceName: "cardinals"))
        self.addMLBTeam(loc: "Chicago",       name: "Cubs",         abbrv: "CHC", logo: #imageLiteral(resourceName: "cubs"))
        self.addMLBTeam(loc: "Arizona",       name: "D-backs",      abbrv: "ARI", logo: #imageLiteral(resourceName: "diamondbacks"))
        self.addMLBTeam(loc: "Los Angeles",   name: "Dodgers",      abbrv: "LAD", logo: #imageLiteral(resourceName: "dodgers"))
        self.addMLBTeam(loc: "San Francisco", name: "Giants",       abbrv: "SF",  logo: #imageLiteral(resourceName: "giants"))
        self.addMLBTeam(loc: "Cleveland",     name: "Indians",      abbrv: "CLE", logo: #imageLiteral(resourceName: "indians"))
        self.addMLBTeam(loc: "Seattle",       name: "Mariners",     abbrv: "SEA", logo: #imageLiteral(resourceName: "mariners"))
        self.addMLBTeam(loc: "Florida",       name: "Marlins",      abbrv: "FLA", logo: #imageLiteral(resourceName: "marlins"))
        self.addMLBTeam(loc: "New York",      name: "Mets",         abbrv: "NYM", logo: #imageLiteral(resourceName: "mets"))
        self.addMLBTeam(loc: "Washington",    name: "Nationals",    abbrv: "WSH", logo: #imageLiteral(resourceName: "nationals"))
        self.addMLBTeam(loc: "Baltimore",     name: "Orioles",      abbrv: "BAL", logo: #imageLiteral(resourceName: "orioles"))
        self.addMLBTeam(loc: "San Diego",     name: "Padres",       abbrv: "SD",  logo: #imageLiteral(resourceName: "padres"))
        self.addMLBTeam(loc: "Philadelphia",  name: "Phillies",     abbrv: "PHI", logo: #imageLiteral(resourceName: "phillies"))
        self.addMLBTeam(loc: "Pittsburgh",    name: "Pirates",      abbrv: "PIT", logo: #imageLiteral(resourceName: "pirates"))
        self.addMLBTeam(loc: "Texas",         name: "Rangers",      abbrv: "TEX", logo: #imageLiteral(resourceName: "rangers-MLB"))
        self.addMLBTeam(loc: "Tampa Bay",     name: "Rays",         abbrv: "TB",  logo: #imageLiteral(resourceName: "rays"))
        self.addMLBTeam(loc: "Boston",        name: "Red Sox",      abbrv: "BOS", logo: #imageLiteral(resourceName: "red-sox"))
        self.addMLBTeam(loc: "Cincinnati",    name: "Reds",         abbrv: "CIN", logo: #imageLiteral(resourceName: "reds"))
        self.addMLBTeam(loc: "Colorado",      name: "Rockies",      abbrv: "COL", logo: #imageLiteral(resourceName: "rockies"))
        self.addMLBTeam(loc: "Kansas City",   name: "Royals",       abbrv: "KAN", logo: #imageLiteral(resourceName: "royals"))
        self.addMLBTeam(loc: "Detroit",       name: "Tigers",       abbrv: "DET", logo: #imageLiteral(resourceName: "tigers"))
        self.addMLBTeam(loc: "Minnesota",     name: "Twins",        abbrv: "MIN", logo: #imageLiteral(resourceName: "twins"))
        self.addMLBTeam(loc: "Chicago",       name: "White Sox",    abbrv: "CWS", logo: #imageLiteral(resourceName: "white-sox"))
        self.addMLBTeam(loc: "New York",      name: "Yankees",      abbrv: "NYY", logo: #imageLiteral(resourceName: "yankees"))
    }

    private func addNHLTeam(loc: String, name: String, abbrv: String, logo: UIImage) {
        self._nhlTeams[name] = Team(location: loc, shortName: name, abbreviation: abbrv, logo: logo, league: .NHL)
    }

    private func addMLBTeam(loc: String, name: String, abbrv: String, logo: UIImage) {
        self._mlbTeams[name] = Team(location: loc, shortName: name, abbreviation: abbrv, logo: logo, league: .MLB)
    }
}
