//
//  GameViewPresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol GameViewPresenterType: class
{
    func loadView()
    func viewDidLoad()
    
    func setGameView(gameView: GameViewControllerType)
    func setGameSettingsView(gameSettingsView: GameSettingsViewControllerType)
    
    func getCDNOptions(completion: @escaping ([CDN]) -> (), error: @escaping () -> ())
    func getPlaylistOptions(completion: @escaping ([FeedPlaylist]) -> (), error: @escaping () -> ())
    func getFeedOptions(completion: @escaping ([Feed]) -> (), error: @escaping () -> ())
    
    func setSelectedCDN(cdn: CDN)
    func setSelectedPlaylist(feedPlaylist: FeedPlaylist)
    func setSelectedFeed(feed: Feed)
}


class GameViewPresenter: GameViewPresenterType
{
    private weak var gameView: GameViewControllerType?
    private weak var gameSettingsView: GameSettingsViewControllerType?
    
    private let game: Game
    
    private var selectedFeed: Feed?
    {
        didSet
        {
            guard let selectedFeed = self.selectedFeed else { return }
            self.gameSettingsView?.setFeed(text: selectedFeed.getTitle())
        }
    }
    
    private var selectedFeedPlaylist: FeedPlaylist?
    {
        didSet
        {
            guard let selectedFeedPlaylist = self.selectedFeedPlaylist else { return }
            self.gameSettingsView?.setQuality(text: selectedFeedPlaylist.getTitle())
        }
    }
    
    private var selectedCDN: CDN!
    {
        didSet
        {
            self.gameSettingsView?.setCDN(text: self.selectedCDN.getTitle())
        }
    }
    
    private let cdnOptions = [CDN.Akamai, CDN.Level3]
    
    init(game: Game)
    {
        self.game = game
    }
    
    func loadView()
    {
        
    }
    
    func viewDidLoad()
    {
        self.gameView?.setTitle(title: "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)")
        
        self.gameSettingsView?.setFeed(text: "")
        self.gameSettingsView?.setQuality(text: "")
        
        self.setSelectedCDN(cdn: .Akamai)
        if self.selectedFeed == nil, self.game.feeds.count > 0
        {
            self.setSelectedFeed(feed: self.game.feeds[0])
        }
    }
    
    func setGameView(gameView: GameViewControllerType)
    {
        self.gameView = gameView
    }
    
    func setGameSettingsView(gameSettingsView: GameSettingsViewControllerType)
    {
        self.gameSettingsView = gameSettingsView
    }
    
    func getGame() -> Game
    {
        return self.game
    }
    
    func setFeed(feed: Feed)
    {
        self.selectedFeed = feed
    }
    
    func getCDNOptions(completion: @escaping ([CDN]) -> (), error: @escaping () -> ())
    {
        completion([.Akamai, .Level3])
    }
    
    func getPlaylistOptions(completion: @escaping ([FeedPlaylist]) -> (), error: @escaping () -> ())
    {
        if let feed = self.selectedFeed
        {
            feed.getFeedPlaylists(cdn: .Akamai, completion: { (feedPlaylists) in
                
                if feedPlaylists.count > 0
                {
                    self.selectedFeedPlaylist = feedPlaylists[0]
                }
                
                completion(feedPlaylists)
            }, error: { (error) in
                
            })
        }
    }
    
    func getFeedOptions(completion: @escaping ([Feed]) -> (), error: @escaping () -> ())
    {
        if self.selectedFeed == nil, self.game.feeds.count > 0
        {
            self.selectedFeed = self.game.feeds[0]
        }
        
        completion(self.game.feeds)
    }
    
    func setSelectedCDN(cdn: CDN)
    {
        self.selectedCDN = cdn
    }
    
    func setSelectedPlaylist(feedPlaylist: FeedPlaylist)
    {
        self.selectedFeedPlaylist = feedPlaylist
    }
    
    func setSelectedFeed(feed: Feed)
    {
        self.selectedFeed = feed
        
        feed.getFeedPlaylists(cdn: self.selectedCDN ?? CDN.Akamai,
                              completion: { (feedPlaylists) in
                                if feedPlaylists.count > 0
                                {
                                    self.setSelectedPlaylist(feedPlaylist: feedPlaylists[0])
                                }
        }) { (error) in
            
        }
    }
}
