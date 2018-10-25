//
//  GamePresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import AVKit

protocol GamePresenterType: class, AVAssetResourceLoaderDelegate {
    
    var gameView: GameViewControllerType? { get set }
    var gameSettingsView: GameSettingsViewControllerType? { get set }
    
//    var qualitySelector: GameOptionSelector<FeedPlaylist>? { get }
//    var feedSelector: GameOptionSelector<Feed> { get }
//    var cdnSelector: GameOptionSelector<CDN> { get }
    
    var game: Game { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func reloadPressed()
}

class GamePresenter: NSObject, GamePresenterType
{
    weak var gameView: GameViewControllerType?
    weak var gameSettingsView: GameSettingsViewControllerType?
    
    let game: Game

    
//    var qualities = [FeedPlaylist]()
    let cdns = [CDN.Akamai, CDN.Level3]
    
    
    var selectedQuality: FeedPlaylist? {
        didSet {
            
            if let playlist = self.selectedQuality {
                self.gameView?.playURL(url: playlist.url)
            }
        }
    }
    var selectedFeed: Feed? {
        didSet {
            self.selectDefaultPlaylist()
        }
    }
    var selectedCDN: CDN {
        didSet {
            self.selectDefaultFeed()
        }
    }
    
    private let settingsManager: SettingsType
    private let feedManager: FeedManagerType
    
    private let cdnOptions = [CDN.Akamai, CDN.Level3]
    
    init(game: Game, settingsManager: SettingsType = SettingsManager.shared, feedManager: FeedManagerType = FeedManager.shared)
    {
        self.game = game
        self.settingsManager = settingsManager
        self.feedManager = feedManager
        
        self.selectedCDN = self.settingsManager.defaultCDN
        
        super.init()
        

    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        self.gameView?.gameTitle = "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)"
        self.selectDefaultFeed()
    }
    
    func reloadPressed()
    {
//        if let selectedFeed = self.feedSelector.selectedObject
//        {
//            self.feedSelected(selected: selectedFeed)
//        }
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
        if ({ return false }()) { // TODO: add french option to settings
            for feed in self.game.feeds {
                if case .french = feed.feedType {
                    self.selectedFeed = feed
                    break
                }
            }
        }
        else if self.game.homeTeam.isFavorite {
            for feed in self.game.feeds {
                if case .home = feed.feedType {
                    self.selectedFeed = feed
                    break
                }
            }
        }
        else if self.game.awayTeam.isFavorite {
            for feed in self.game.feeds {
                if case .away = feed.feedType {
                    self.selectedFeed = feed
                    break
                }
            }
        }
        else {
            self.selectedFeed = self.game.feeds.first
        }
    }
    
    private func selectDefaultPlaylist() {
        guard let feed = self.selectedFeed else { return }
        
        self.feedManager.getFeedPlaylists(from: feed, using: self.selectedCDN, ignoreCache: false) { result in
            switch result {
            case .failure(let _):
                return
            case .success(let playlists):
                self.selectedQuality = playlists.first
                return
            }
        }
        
    }
    
    
    private func qualitySelected(selected: FeedPlaylist)
    {
//        self.gameSettingsView?.setQuality(text: selected.getTitle())
//        self.gameView?.playURL(url: selected.getURL())
    }
    
    private func cdnSelected(selected: CDN)
    {
//        self.gameSettingsView?.setCDN(text: selected.getTitle())
//        if let selectedFeed = self.feedSelector.selectedObject
//        {
//            self.gameSettingsView?.setQuality(text: nil)
//            self.qualitySelector = nil
//
//            selectedFeed.getFeedPlaylists(cdn: selected, completion: { (feedPlaylists) in
//                self.qualitySelector = GameOptionSelector<FeedPlaylist>(objects: feedPlaylists)
//                self.qualitySelector?.onSelection = self.qualitySelected
//
//                if feedPlaylists.count > SettingsManager.shared.defaultQuality { self.qualitySelector?.select(index: SettingsManager.shared.defaultQuality) }
//
//            }) { (error) in
//                self.gameView?.showError(message: error)
//                self.gameSettingsView?.setQuality(text: "")
//            }
//        }
    }
    
    private func feedSelected(selected: Feed)
    {
//        self.gameSettingsView?.setFeed(text: selected.getTitle())
//        self.gameSettingsView?.setQuality(text: nil)
//        self.qualitySelector = nil
//        
//        selected.getFeedPlaylists(cdn: self.cdnSelector.selectedObject!, completion: { (feedPlaylists) in
//            self.qualitySelector = GameOptionSelector<FeedPlaylist>(objects: feedPlaylists)
//            self.qualitySelector?.onSelection = self.qualitySelected
//            
//            if feedPlaylists.count > SettingsManager.shared.defaultQuality { self.qualitySelector?.select(index: SettingsManager.shared.defaultQuality) }
//            
//        }) { (error) in
//            self.gameView?.showError(message: error)
//            self.gameSettingsView?.setQuality(text: "")
//        }
    }
}
