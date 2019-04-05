//
//  GamePresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import AVKit
import OptionSelector

protocol GamePresenterType: AVAssetResourceLoaderDelegate {
    
    var gameView: GameViewType? { get set }

    var cdnSelector: SingularOptionSelector<CDN> { get }
    var feedSelector: SingularOptionSelector<Feed> { get }
    var playlistSelector: SingularOptionSelector<Playlist>? { get }
    
    var game: Game { get }
    
    func load()
    func reload()
}

class GamePresenter: NSObject, GamePresenterType {

    weak var gameView: GameViewType?
    
    let game: Game
    private (set) var cdnSelector: SingularOptionSelector<CDN>
    private (set) var feedSelector: SingularOptionSelector<Feed>
    private (set) var playlistSelector: SingularOptionSelector<Playlist>? {
        didSet {
            self.playlistSelector?.callback = { [weak self] selected in
                self?.didSelectPlaylist(playlist: selected)
            }
        }
    }
    
    private let settingsManager: SettingsType
    private let feedManager: FeedManagerType
    private let teamManager: TeamManagerType

    // MARK: - Initialization

    deinit {
        print("DEINIT GP")
    }
    
    init?(game: Game,
         settingsManager: SettingsType = SettingsManager.shared,
         feedManager: FeedManagerType = FeedManager.shared,
         teamManager: TeamManagerType = TeamManager.shared) {
        self.game = game
        self.settingsManager = settingsManager
        self.feedManager = feedManager
        self.teamManager = teamManager

        guard let defaultFeed = teamManager.getDefaultFeed(game: game),
            let cdnSelector = SingularOptionSelector(options: CDN.allCases, selected: settingsManager.defaultCDN),
            let feedSelector = SingularOptionSelector(options: game.feeds, selected: defaultFeed) else
        {
            return nil
        }
        self.cdnSelector = cdnSelector
        self.feedSelector = feedSelector

        super.init()

        self.cdnSelector.callback = { [weak self] selected in
            self?.didSelectCDN(cdn: selected)
        }
        self.feedSelector.callback = { [weak self] selected in
            self?.didSelectFeed(feed: selected)
        }
    }
    
    func load() {
        self.gameView?.setQuality(text: nil)
        self.gameView?.setFeed(text: self.feedSelector.selected.title)
        self.gameView?.setCDN(text: self.cdnSelector.selected.title)
        self.gameView?.gameTitle = "\(self.game.awayTeam.shortName) at \(self.game.homeTeam.shortName)"
        self.loadPlaylists(reload: false)
    }

    func reload() {
        self.loadPlaylists(reload: true)
    }
    
    // MARK: - AVAssetResourceLoaderDelegate
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool
    {
        if let url = loadingRequest.request.url {
            for host in allHosts {
                if url.absoluteString.contains(host),
                    let redirect = URL(string: url.absoluteString.replacingOccurrences(of: host, with: serverAddress))
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

    private func didSelectCDN(cdn: CDN) {
        self.gameView?.setCDN(text: cdn.title)
        self.loadPlaylists()
    }

    private func didSelectFeed(feed: Feed) {
        self.gameView?.setFeed(text: feed.title)
        self.loadPlaylists()
    }

    private func didSelectPlaylist(playlist: Playlist) {
        self.gameView?.setQuality(text: playlist.title)
        self.gameView?.playURL(url: playlist.url)
    }

    private func loadPlaylists(reload: Bool = false) {
        self.gameView?.setQuality(text: nil)
        self.feedManager.getFeedPlaylists(from: self.feedSelector.selected, using: self.cdnSelector.selected, ignoreCache: reload) {
            self.handlePlaylist(result: $0)
        }
    }

    private func handlePlaylist(result: Result<[Playlist], StringError>) {
        switch result {
        case .failure(let error):
            self.gameView?.setQuality(text: "")
            self.gameView?.showError(message: error.error)
        case .success(let playlists):
            var defaultPlaylist = playlists.first
            if playlists.count >= 2  {
                defaultPlaylist = playlists[self.settingsManager.defaultQuality]
            }
            guard !playlists.isEmpty, let selected = defaultPlaylist else {
                return
            }
            self.playlistSelector = SingularOptionSelector(options: playlists, selected: selected)
            self.didSelectPlaylist(playlist: selected)
        }
    }
}
