//
//  GamePresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol GamePresenterType: class
{
    var gameView: GameViewControllerType? { get set }
    var gameSettingsView: GameSettingsViewControllerType? { get set }
    
    var qualitySelector: GameOptionSelector<FeedPlaylist>? { get }
    var feedSelector: GameOptionSelector<Feed> { get }
    var cdnSelector: GameOptionSelector<CDN> { get }
    
    var game: Game { get }
    var selectingOption: Bool { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func reloadPressed()
}

class GamePresenter: GamePresenterType
{
    weak var gameView: GameViewControllerType?
    weak var gameSettingsView: GameSettingsViewControllerType?
    
    let game: Game
    
    var qualitySelector: GameOptionSelector<FeedPlaylist>?
    let feedSelector: GameOptionSelector<Feed>
    let cdnSelector: GameOptionSelector<CDN>
    var selectingOption = false
    
    private let cdnOptions = [CDN.Akamai, CDN.Level3]
    
    init(game: Game)
    {
        self.game = game
        
        self.cdnSelector = GameOptionSelector<CDN>(objects: [CDN.Akamai, CDN.Level3])
        self.feedSelector = GameOptionSelector<Feed>(objects: game.feeds)
        
        self.cdnSelector.onSelection = self.cdnSelected
        self.feedSelector.onSelection = self.feedSelected
    }
    
    func viewDidLoad()
    {
        self.cdnSelector.select(index: 0)
        if self.feedSelector.count > 0 { self.feedSelector.select(index: 0) }
    }
    
    func viewWillAppear()
    {
        self.gameView?.gameTitle = "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)"
        
        // play the feed if this view appears somehow and we aren't coming from options
        if let feedPlaylist = self.qualitySelector?.selectedObject, !self.selectingOption
        {
            self.gameView?.playURL(url: feedPlaylist.getURL())
        }
        self.selectingOption = false
    }
    
    func reloadPressed()
    {
        if let selectedFeed = self.feedSelector.selectedObject
        {
            self.feedSelected(selected: selectedFeed)
        }
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
                
                if feedPlaylists.count > 0 { self.qualitySelector?.select(index: 0) }
                
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
            
            if feedPlaylists.count > 1 { self.qualitySelector?.select(index: 1) }
            
        }) { (error) in
            self.gameView?.showError(message: error)
            self.gameSettingsView?.setQuality(text: "")
        }
    }
}
