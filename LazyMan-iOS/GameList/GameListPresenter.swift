//
//  GameListPresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/5/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol GameListPresenterType: class
{
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    
    func refreshPressed()
    func datePressed()
    func dateSelected(date: Date)
    func leagueChanged(league: League)
    
    func getGameCount() -> Int
    func getGames() -> [Game]
}

class GameListPresenter: GameListPresenterType
{
    // MARK: - Properties
    
    private weak var view: GameListViewControllerType?
    
    private var currentDate = Date() {
        didSet {
            guard !Calendar.current.isDate(oldValue, inSameDayAs: currentDate) else { return }
            self.view?.updateDate(date: currentDate)
            self.loadGames()
        }
    }
    
    private var games = [Game]() {
        didSet {
            self.view?.updateGames()
            self.view?.updateError(error: nil)
        }
    }
    
    private var league = League.NHL {
        didSet {
            self.loadGames()
        }
    }
    
    init(view: GameListViewControllerType)
    {
        self.view = view
    }
    
    // MARK: - GameListPresenterType
    
    func viewDidLoad()
    {
        
    }
    
    func viewWillAppear()
    {
        self.view?.updateCalendar(date: self.currentDate)
        self.view?.updateDate(date: self.currentDate)
        self.loadGames()
    }
    
    func viewDidAppear()
    {
        
    }
    
    func refreshPressed()
    {
        self.reloadGames()
    }
    
    func datePressed()
    {
        self.view?.showDatePicker(currentDate: self.currentDate)
    }
    
    func dateSelected(date: Date)
    {
        self.currentDate = date
    }
    
    func leagueChanged(league: League)
    {
        self.league = league
    }
    
    func getGameCount() -> Int
    {
        return self.games.count
    }
    
    func getGames() -> [Game]
    {
        return self.games
    }
    
    // MARK: - Private
    
    private func loadGames()
    {
        self.games = []
        
        if let games = GameManager.manager.getGames(date: self.currentDate, league: self.league)
        {
            self.games = games
            self.view?.updateRefreshing(refreshing: false)
        }
        else
        {
            self.view?.updateRefreshing(refreshing: true)
            self.gameManagerReload()
        }
    }
    
    private func reloadGames()
    {
        self.games = []
        self.gameManagerReload()
    }
    
    private func gameManagerReload()
    {
        GameManager.manager.reloadGames(date: self.currentDate, league: self.league, completion: { (games) in
            self.games = games
            self.view?.updateRefreshing(refreshing: false)
        }, error: { (error) in
            self.view?.updateError(error: error)
            self.view?.updateRefreshing(refreshing: false)
        })
    }
}
