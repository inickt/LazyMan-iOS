//
//  GameViewPresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameViewPresenter
{
    private weak var gameView: GameViewController?
    
    private let game: Game
    private var selectedFeed: Feed?
    private var selectedFeedPlaylist: FeedPlaylist?
    
    
    
    
    func getCDNOptions() -> [GameOptionCellText]
    {
        return [CDN.Akamai, CDN.Level3]
    }
    
    func getQualityOptions() -> [GameOptionCellText]
    {
        return []
    }
    
    func getFeedOptions() -> [GameOptionCellText]
    {
        return fee
    }
    
    
    
}
