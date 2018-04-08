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
    // MARK: - Properties
    
    var opetionSelector: AnyGameViewOptionSelector?
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.opetionSelector?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let opetionSelector = self.opetionSelector else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameOptionCell", for: indexPath)
        
        cell.textLabel?.text = opetionSelector.getObjects()[indexPath.row].getTitle()
        cell.detailTextLabel?.text = opetionSelector.getObjects()[indexPath.row].getDetail()
        cell.accessoryType = indexPath.row == opetionSelector.selectedIndex ?? -1 ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndex = self.opetionSelector?.selectedIndex
        {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
        }
        self.opetionSelector?.select(index: indexPath.row)
        
        // update the checkmark for the current row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
}
