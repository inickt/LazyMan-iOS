//
//  GamePresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import AVKit

protocol GamePresenterType: AVAssetResourceLoaderDelegate, GameSettingsOptionsDelegate {
    
    var gameView: GameViewControllerType? { get set }
    var gameSettingsView: GameSettingsViewControllerType? { get set }
    
    var cdnOptions: (options: [CDN], selected: CDN) { get }
    var feedOptions: (options: [Feed], selected: Feed?) { get }
    var playlistOptions: (options: [FeedPlaylist], selected: FeedPlaylist?) { get }
    
    var game: Game { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func reloadPressed()
}

class GamePresenter: NSObject, GamePresenterType {
    
    weak var gameView: GameViewControllerType?
    weak var gameSettingsView: GameSettingsViewControllerType?
    
    let game: Game

    
    var cdnOptions: (options: [CDN], selected: CDN) {
        return ([CDN.Akamai, CDN.Level3], self.selectedCDN)
    }
    
    var feedOptions: (options: [Feed], selected: Feed?) {
        return (self.game.feeds, self.selectedFeed)
    }
    
    var playlistOptions: (options: [FeedPlaylist], selected: FeedPlaylist?) {
        return (self.playlists ?? [], self.selectedPlaylist)
    }
    
    var playlists: [FeedPlaylist]?
    
    var selectedPlaylist: FeedPlaylist? {
        didSet {
            if let selectedPlaylist = self.selectedPlaylist {
                self.gameSettingsView?.setQuality(text: selectedPlaylist.title)
                self.gameView?.playURL(url: selectedPlaylist.url)
            }
        }
    }
    var selectedFeed: Feed? {
        didSet {
            if let selectedFeed = self.selectedFeed {
                self.selectDefaultPlaylist()
                self.gameSettingsView?.setFeed(text: selectedFeed.title)
            }
        }
    }
    var selectedCDN: CDN {
        didSet {
            self.selectDefaultFeed()
            self.gameSettingsView?.setCDN(text: self.selectedCDN.title)
        }
    }
    
    private let settingsManager: SettingsType
    private let feedManager: FeedManagerType
    
    // MARK: - Initialization
    
    init(game: Game, settingsManager: SettingsType = SettingsManager.shared, feedManager: FeedManagerType = FeedManager.shared) {
        self.game = game
        self.settingsManager = settingsManager
        self.feedManager = feedManager
        
        self.selectedCDN = self.settingsManager.defaultCDN
        
        super.init()
    }
    
    func viewDidLoad() {
        self.gameSettingsView?.setCDN(text: self.selectedCDN.title)
        self.gameSettingsView?.setQuality(text: nil)
    }
    
    func viewWillAppear() {
        self.gameView?.gameTitle = "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)"
        if self.selectedFeed == nil {
            self.selectDefaultFeed()
        }
    }
    
    func reloadPressed() {
        if let selectedFeed = self.selectedFeed {
            self.gameSettingsView?.setQuality(text: nil)
            self.feedManager.getFeedPlaylists(from: selectedFeed, using: self.selectedCDN, ignoreCache: true) { result in
                self.handleFeedPlaylist(result: result)
            }
        }
    }
    
    func didSelectCDN(option: CDN) {
        self.selectedCDN = option
    }
    
    func didSelectFeed(option: Feed) {
        self.selectedFeed = option
    }
    
    func didSelectPlaylist(option: FeedPlaylist) {
        self.selectedPlaylist = option
    }
    
    // MARK: - AVAssetResourceLoaderDelegate
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool
    {
        if let url = loadingRequest.request.url
        {
            for host in allHosts
            {
                if url.absoluteString.contains(host), let redirect = URL(string: url.absoluteString.replacingOccurrences(of: host, with: serverAddress))
                {
                    try? loadingRequest.dataRequest?.respond(with: Data(contentsOf: redirect))
                    loadingRequest.finishLoading()
                    return true
                }
            }
        }

        return false
    }
    
    // MARK: - Private
    
    private func selectDefaultFeed() {
        if ({ false }()) { // TODO: add french option to settings
            for feed in self.game.feeds {
                if case .french = feed.feedType {
                    self.selectedFeed = feed
                    return
                }
            }
        }
        // TODO: Bad singleton access?
        else if TeamManager.shared.isFavorite(team: self.game.homeTeam) {
            for feed in self.game.feeds {
                if case .home = feed.feedType {
                    self.selectedFeed = feed
                    return
                }
            }
        }
        // TODO: Bad singleton access?
        else if TeamManager.shared.isFavorite(team: self.game.awayTeam) {
            for feed in self.game.feeds {
                if case .away = feed.feedType {
                    self.selectedFeed = feed
                    return
                }
            }
        }
        
        // If all of the above fails, select the first if we have it
        self.selectedFeed = self.game.feeds.first
    }
    
    private func selectDefaultPlaylist() {
        guard let feed = self.selectedFeed else { return }
        
        self.feedManager.getFeedPlaylists(from: feed, using: self.selectedCDN, ignoreCache: false) { result in
            self.handleFeedPlaylist(result: result)
        }
    }
    
    private func handleFeedPlaylist(result: Result<[FeedPlaylist], StringError>) {
        switch result {
        case .failure(let _):
            self.gameSettingsView?.setQuality(text: "")
            return
        case .success(let playlists):
            self.playlists = playlists
            guard playlists.count >= 2 else {
                self.selectedPlaylist = playlists.first
                return
            }
            self.selectedPlaylist = playlists[self.settingsManager.defaultQuality]
            return
        }
    }
}
