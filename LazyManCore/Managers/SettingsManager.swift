//
//  SettingsManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 4/27/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public protocol SettingsManagerType {
    var defaultLeague: League { get set }
    var defaultQuality: Quality { get set }
    var defaultCDN: CDN { get set }
    var preferFrench: Bool { get set }
    var showScores: Bool { get set }
    var favoriteNHLTeams: [Team] { get set }
    var favoriteMLBTeams: [Team] { get set }
    var notifications: Bool { get set }
    var versionUpdates: Bool { get set }
    var betaUpdates: Bool { get set }
}

public class SettingsManager: SettingsManagerType {

    // MARK: - Shared

    public static let shared = SettingsManager()

    // MARK: - Persisted Properties

    private let defaultLeagueKey = "defaultLeague"
    public var defaultLeague: League {
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
    public var defaultQuality: Quality {
        get {
            return Quality(rawValue: UserDefaults.standard.integer(forKey: defaultQualityKey)) ?? .best
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultQualityKey)
        }
    }

    private let defaultCDNKey = "defaultCDN"
    public var defaultCDN: CDN {
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
    public var preferFrench: Bool {
        get {
            return UserDefaults.standard.bool(forKey: preferFrenchKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: preferFrenchKey)
        }
    }

    private let showScoresKey = "showScores"
    public var showScores: Bool {
        get {
            return UserDefaults.standard.bool(forKey: showScoresKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: showScoresKey)
        }
    }

    private let favoriteNHLTeamsKey = "favoriteNHLTeams"
    public var favoriteNHLTeams: [Team] {
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
                UserDefaults.standard.set(newValue.map { $0.teamName }, forKey: favoriteNHLTeamsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: favoriteNHLTeamsKey)
            }
        }
    }

    private let favoriteMLBTeamsKey = "favoriteMLBTeams"
    public var favoriteMLBTeams: [Team] {
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
                UserDefaults.standard.set(newValue.map { $0.teamName }, forKey: favoriteMLBTeamsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: favoriteMLBTeamsKey)
            }
        }
    }

    private let notificationsKey = "notifications"
    public var notifications: Bool {
        get {
            return UserDefaults.standard.bool(forKey: notificationsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: notificationsKey)
        }
    }

    private let versionUpdatesKey = "versionUpdates"
    public var versionUpdates: Bool {
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
    public var betaUpdates: Bool {
        get {
            return UserDefaults.standard.bool(forKey: betaUpdatesKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: betaUpdatesKey)
        }
    }
}
