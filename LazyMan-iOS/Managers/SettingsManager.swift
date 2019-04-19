//
//  SettingsManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/27/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

protocol SettingsManagerType {
    var defaultLeague: League { get set }
    var defaultQuality: Quality { get set }
    var defaultCDN: CDN { get set }
    var preferFrench: Bool { get set }
    var favoriteNHLTeams: [Team] { get set }
    var favoriteMLBTeams: [Team] { get set }
    var versionUpdates: Bool { get set }
    var betaUpdates: Bool { get set }
}

class SettingsManager: SettingsManagerType {

    // MARK: - Shared

    static let shared = SettingsManager()

    // MARK: - Persisted Properties

    private let defaultLeagueKey = "defaultLeague"
    var defaultLeague: League {
        get {
            guard let value = UserDefaults.standard.string(forKey: defaultLeagueKey),
                let league = League(rawValue: value) else {
                return .NHL
            }
            return league
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultLeagueKey)
        }
    }

    private let defaultQualityKey = "defaultQuality"
    var defaultQuality: Quality {
        get {
            return Quality(rawValue: UserDefaults.standard.integer(forKey: defaultQualityKey)) ?? .best
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultQualityKey)
        }
    }

    private let defaultCDNKey = "defaultCDN"
    var defaultCDN: CDN {
        get {
            guard let value = UserDefaults.standard.string(forKey: defaultCDNKey), let cdn = CDN(rawValue: value) else {
                return .akamai
            }
            return cdn
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultCDNKey)
        }
    }

    private let preferFrenchKey = "preferFrench"
    var preferFrench: Bool {
        get {
            return UserDefaults.standard.bool(forKey: preferFrenchKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: preferFrenchKey)
        }
    }

    private let favoriteNHLTeamsKey = "favoriteNHLTeams"
    var favoriteNHLTeams: [Team] {
        get {
            if let values = UserDefaults.standard.stringArray(forKey: favoriteNHLTeamsKey) {
                // TODO: Bad singleton access (but creates circular dep)
                return values.compactMap { TeamManager.shared.nhlTeams[$0] }
            } else {
                return []
            }
        }
        set {
            if newValue.allSatisfy({ $0.league == .NHL }) {
                UserDefaults.standard.set(newValue.map { $0.shortName }, forKey: favoriteNHLTeamsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: favoriteNHLTeamsKey)
            }
        }
    }

    private let favoriteMLBTeamsKey = "favoriteMLBTeams"
    var favoriteMLBTeams: [Team] {
        get {
            if let values = UserDefaults.standard.stringArray(forKey: favoriteMLBTeamsKey) {
                // TODO: Bad singleton access (but creates circular dep)
                return values.compactMap { TeamManager.shared.mlbTeams[$0] }
            } else {
                return []
            }
        }
        set {
            if newValue.allSatisfy({ $0.league == .MLB }) {
                UserDefaults.standard.set(newValue.map { $0.shortName }, forKey: favoriteMLBTeamsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: favoriteMLBTeamsKey)
            }
        }
    }

    private let versionUpdatesKey = "versionUpdates"
    var versionUpdates: Bool {
        get {
            if UserDefaults.standard.object(forKey: versionUpdatesKey) != nil {
                return UserDefaults.standard.bool(forKey: versionUpdatesKey)
            } else {
                return true
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: versionUpdatesKey)
        }
    }

    private let betaUpdatesKey = "betaUpdates"
    var betaUpdates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: betaUpdatesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: betaUpdatesKey)
        }
    }
}
