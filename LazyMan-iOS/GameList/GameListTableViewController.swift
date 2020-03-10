//
//  GameListTableViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/24/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import LazyManCore

class GameListTableViewController: UITableViewController {

    // MARK: - Properties

    weak var gameListView: GameListViewControllerType?
    var date: Date!
    var league: League!
    private var games: [Game]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace the background view with custom view with error label
        let backgroundView = GameListTableBackgroundView.instanceFromNib()
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView

        self.tableView.separatorColor = .darkGray
        self.refreshControl?.tintColor = .lightGray
        self.refreshControl?.addTarget(self, action: #selector(refreshPressed), for: .valueChanged)
        self.updateError(message: nil)

        GameManager.manager.getGames(date: self.date, league: self.league, ignoreCache: false) { result in
            switch result {
            case .success(let games):
                self.games = games.sorted(by: TeamManager.shared.compareGames)
            case .failure(let error):
                self.updateError(message: error.messgae)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Updates games silently to refresh time remaining. If the refresh fails it will keep existing data.
        GameManager.manager.getGames(date: self.date, league: self.league, ignoreCache: false) { result in
            switch result {
            case .success(let games):
                self.games = games.sorted(by: TeamManager.shared.compareGames)
            case .failure(let error):
                if self.games == nil {
                    self.updateError(message: error.messgae)
                }
            }
        }
    }

    // MARK: - Private

    @objc
    private func refreshPressed() {
        // Clears out the existing data, and reloads the games.
        self.games = nil
        self.updateError(message: nil)

        GameManager.manager.getGames(date: self.date, league: self.league, ignoreCache: true) { result in
            switch result {
            case .success(let games):
                self.games = games.sorted(by: TeamManager.shared.compareGames)
                self.refreshControl?.endRefreshing()
            case .failure(let error):
                if self.games == nil {
                    self.updateError(message: error.messgae)
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    private func updateError(message: String?) {
        (self.tableView.backgroundView as? GameListTableBackgroundView)?.errorMessage = message
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell",
                                                       for: indexPath) as? GameTableViewCell,
            let games = self.games,
            games.count > indexPath.row
            else {
            return UITableViewCell()
        }

        cell.game = games[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame",
            let navController = segue.destination as? UINavigationController,
            let gameVC = navController.topViewController as? GameViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = self.tableView.indexPath(for: cell),
            let games = self.games,
            games.count > indexPath.row {
            self.gameListView?.collapseDetailViewController = false
            gameVC.presenter = GamePresenter(game: games[indexPath.row])
            gameVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            gameVC.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
