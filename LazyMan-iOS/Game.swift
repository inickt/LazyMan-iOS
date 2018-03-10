//
//  Game.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class Game
{
    let homeTeam: Team
    let awayTeam: Team
    let startTime: Date
    let gameState: String
    let feeds: [Feed]
    
    init(homeTeam: Team, awayTeam: Team, startTime: Date, gameState: String, feeds: [Feed])
    {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.startTime = startTime
        self.gameState = gameState
        self.feeds = feeds
    }
    
}
