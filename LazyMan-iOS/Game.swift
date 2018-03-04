//
//  Game.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class Game: NSObject
{
    let homeTeam: Team
    let awayTeam: Team
    
    
    var time: String {
        return "FINAL"
    }
    
    private init(homeTeam: Team, awayTeam: Team)
    {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    
    convenience init(homeTeam: NHLTeam, awayTeam: NHLTeam)
    {
        self.init(homeTeam: homeTeam, awayTeam: awayTeam)
    }
    
    convenience init(homeTeam: MLBTeam, awayTeam: MLBTeam)
    {
        self.init(homeTeam: homeTeam, awayTeam: awayTeam)
    }
    
}
