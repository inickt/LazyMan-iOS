//
//  SettingsManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/27/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class SettingsManager
{
    static let shared = SettingsManager()
    
    // MARK: - Persisted Properties
    
    private let defaultLeagueKey = "defaultLeague"
    var defaultLeague: League {
        get {
            if let value = UserDefaults.standard.string(forKey: defaultLeagueKey),
                let league = League(rawValue: value)
            {
                return league
            }
            else
            {
                return .NHL
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultLeagueKey)
        }
    }
    
    private let defaultQualityKey = "defaultQuality"
    var defaultQuality: Int {
        get {
            return UserDefaults.standard.integer(forKey: defaultQualityKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: defaultQualityKey)
        }
    }
    
    private let defaultCDNKey = "defaultCDN"
    var defaultCDN: CDN {
        get {
            if let value = UserDefaults.standard.string(forKey: defaultCDNKey),
                let cdn = CDN(rawValue: value)
            {
                return cdn
            }
            else
            {
                return .Akamai
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultCDNKey)
        }
    }
    
    private let favoriteNHLTeamKey = "favoriteNHLTeam"
    var favoriteNHLTeam: Team? {
        get {
            if let value = UserDefaults.standard.string(forKey: favoriteNHLTeamKey),
                let team = TeamManager.nhlTeams[value]
            {
                return team
            }
            else
            {
                return nil
            }
        }
        set {
            if let newValue = newValue, newValue.league == .NHL
            {
                UserDefaults.standard.set(newValue.shortName, forKey: favoriteNHLTeamKey)
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: favoriteNHLTeamKey)
            }
        }
    }
    
    private let favoriteMLBTeamKey = "favoriteMLBTeam"
    var favoriteMLBTeam: Team? {
        get {
            if let value = UserDefaults.standard.string(forKey: favoriteMLBTeamKey),
                let team = TeamManager.mlbTeams[value]
            {
                return team
            }
            else
            {
                return nil
            }
        }
        set {
            if let newValue = newValue, newValue.league == .MLB
            {
                UserDefaults.standard.set(newValue.shortName, forKey: favoriteMLBTeamKey)
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: favoriteMLBTeamKey)
            }
        }
    }
    
    private let hostWarningsKey = "hostWarnings"
    var hostWarnings: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hostWarningsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hostWarningsKey)
        }
    }
    
    private let versionUpdatesKey = "versionUpdates"
    var versionUpdates: Bool {
        get {
            if UserDefaults.standard.object(forKey: versionUpdatesKey) != nil
            {
                return UserDefaults.standard.bool(forKey: versionUpdatesKey)
            }
            else
            {
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
