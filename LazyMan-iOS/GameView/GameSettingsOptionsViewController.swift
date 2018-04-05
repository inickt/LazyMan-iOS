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
    
    var opetionSelector: GameViewOptionSelector<GameOptionCellText>!
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.opetionSelector.objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameOptionCell", for: indexPath)
        
        cell.textLabel?.text = self.opetionSelector.objects[indexPath.row].getTitle()
        cell.detailTextLabel?.text = self.opetionSelector.objects[indexPath.row].getDetail()

        cell.accessoryType = indexPath.row == self.opetionSelector.getSelectedIndex() ?? -1 ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndex = self.opetionSelector.getSelectedIndex()
        {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
        }
        
        self.opetionSelector.selectOption(index: indexPath.row)
        
        // update the checkmark for the current row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }
}
