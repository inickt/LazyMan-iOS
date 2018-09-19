//
//  GameSettingsOptionsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol GameSettingsCellType {
    var title: String { get }
    var description: String { get }
}

extension GameSettingsCellType {
    var description: String {
        return ""
    }
}

extension CDN: GameSettingsCellType {}

class GameSettingsOptionsViewController<T: GameSettingsCellType>: UITableViewController {
    
    // MARK: - Properties
    
    var optionSelector: ObjectSelector<T>? {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionSelector?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let optionSelector = self.optionSelector else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameOptionCell", for: indexPath)
        
        cell.textLabel?.text = optionSelector.objects[indexPath.row].title
        cell.detailTextLabel?.text = optionSelector.objects[indexPath.row].description
        cell.accessoryType = indexPath.row == optionSelector.selectedIndex ?? -1 ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndex = self.optionSelector?.selectedIndex {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
        }
        self.optionSelector?.select(index: indexPath.row)
        
        // update the checkmark for the current row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.navigationController?.popViewController(animated: true)
    }
}
