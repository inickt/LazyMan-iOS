//
//  GameManager.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/3/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

class GameManager
{
    
    
    
    private var games: (nhlGames: [Date : [Game]], mlbGames: [Date : [Game]]) = (nhlGames: [:], mlbGames: [:])
    
    func getGames(date: Date) -> (nhlGames: [Game]?, mlbGames: [Game]?)
    {
        if let nhlGames = self.games.nhlGames[date], let mlbGames = self.games.mlbGames[date]
        {
            return (nhlGames: nhlGames, mlbGames: mlbGames)
        }
        else
        {
            return self.reloadGames(date: date)
        }
    }
    
    func reloadGames(date: Date) -> (nhlGames: [Game]?, mlbGames: [Game]?)
    {
        return (nhlGames: self.getNHLGames(date: date), mlbGames: self.getMLBGames(date: date))
    }
    
    private func getNHLGames(date: Date) -> [Game]?
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.string(from: date)
        
        return nil
    }
    
    private func getMLBGames(date: Date) -> [Game]?
    {
        return nil
    }
    
}

