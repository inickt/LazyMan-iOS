//
//  GamePresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import AVKit

protocol GamePresenterType: class, AVAssetResourceLoaderDelegate
{
    var gameView: GameViewControllerType? { get set }
    var gameSettingsView: GameSettingsViewControllerType? { get set }
    
    var qualitySelector: GameOptionSelector<FeedPlaylist>? { get }
    var feedSelector: GameOptionSelector<Feed> { get }
    var cdnSelector: GameOptionSelector<CDN> { get }
    
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
    
    var qualitySelector: GameOptionSelector<FeedPlaylist>?
    let feedSelector: GameOptionSelector<Feed>
    let cdnSelector: GameOptionSelector<CDN>
    
    private let cdnOptions = [CDN.Akamai, CDN.Level3]
    
    init(game: Game)
    {
        self.game = game
        
        self.cdnSelector = GameOptionSelector<CDN>(objects: [CDN.Akamai, CDN.Level3])
        self.feedSelector = GameOptionSelector<Feed>(objects: game.feeds)
        
        super.init()
        
        self.cdnSelector.onSelection = self.cdnSelected
        self.feedSelector.onSelection = self.feedSelected
    }
    
    func viewDidLoad()
    {
        self.cdnSelector.select(index: SettingsManager.shared.defaultCDN == .Akamai ? 0 : 1)
        if self.feedSelector.count > 0 { self.feedSelector.select(index: 0) }
    }
    
    func viewWillAppear()
    {
        self.gameView?.gameTitle = "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)"
    }
    
    func reloadPressed()
    {
        if let selectedFeed = self.feedSelector.selectedObject
        {
            self.feedSelected(selected: selectedFeed)
        }
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
    
    private func qualitySelected(selected: FeedPlaylist)
    {
        self.gameSettingsView?.setQuality(text: selected.getTitle())
        self.gameView?.playURL(url: selected.getURL())
    }
    
    private func cdnSelected(selected: CDN)
    {
        self.gameSettingsView?.setCDN(text: selected.getTitle())
        if let selectedFeed = self.feedSelector.selectedObject
        {
            self.gameSettingsView?.setQuality(text: nil)
            self.qualitySelector = nil
            
            selectedFeed.getFeedPlaylists(cdn: selected, completion: { (feedPlaylists) in
                self.qualitySelector = GameOptionSelector<FeedPlaylist>(objects: feedPlaylists)
                self.qualitySelector?.onSelection = self.qualitySelected
                
                if feedPlaylists.count > SettingsManager.shared.defaultQuality { self.qualitySelector?.select(index: SettingsManager.shared.defaultQuality) }
                
            }) { (error) in
                self.gameView?.showError(message: error)
                self.gameSettingsView?.setQuality(text: "")
            }
        }
    }
    
    private func feedSelected(selected: Feed)
    {
        self.gameSettingsView?.setFeed(text: selected.getTitle())
        self.gameSettingsView?.setQuality(text: nil)
        self.qualitySelector = nil
        
        selected.getFeedPlaylists(cdn: self.cdnSelector.selectedObject!, completion: { (feedPlaylists) in
            self.qualitySelector = GameOptionSelector<FeedPlaylist>(objects: feedPlaylists)
            self.qualitySelector?.onSelection = self.qualitySelected
            
            if feedPlaylists.count > SettingsManager.shared.defaultQuality { self.qualitySelector?.select(index: SettingsManager.shared.defaultQuality) }
            
        }) { (error) in
            self.gameView?.showError(message: error)
            self.gameSettingsView?.setQuality(text: "")
        }
    }
}
