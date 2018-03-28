//
//  GameSettingsOptionsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameSettingsOptionsViewController: UITableViewController
{
    enum OptionType
    {
        case optionCDN, optionQuality, optionFeed
    }
    
    var options = [GameOptionCellText]()
    {
        didSet
        {            
            self.tableView.reloadData()
        }
    }
    
    var selectedIndex = 0
    
    var presenter: GameViewPresenter!
    var option: OptionType!

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameOptionCell", for: indexPath)
        
        cell.textLabel?.text = self.options[indexPath.row].getTitle()
        cell.detailTextLabel?.text = self.options[indexPath.row].getDetail()

        cell.accessoryType = indexPath.row == self.selectedIndex ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.cellForRow(at: IndexPath(row: self.selectedIndex, section: 0))?.accessoryType = .none
        
//        selectedGame = games[indexPath.row]
        
        // update the checkmark for the current row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.selectedIndex = indexPath.row
        
        switch self.option
        {
        case .optionCDN:
            guard let cdn = self.options[indexPath.row] as? CDN else { return }
            self.presenter.setSelectedCDN(cdn: cdn)
            
        case .optionQuality:
            guard let feedPlaylist = self.options[indexPath.row] as? FeedPlaylist else { return }
            self.presenter.setSelectedPlaylist(feedPlaylist: feedPlaylist)
            
        case .optionFeed:
            guard let feed = self.options[indexPath.row] as? Feed else { return }
            self.presenter.setSelectedFeed(feed: feed)
            
        default:
            return
        }
    }
}
