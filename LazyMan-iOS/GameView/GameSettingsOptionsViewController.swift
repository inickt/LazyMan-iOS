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
extension Feed: GameSettingsCellType {}
extension FeedPlaylist: GameSettingsCellType {}


class GameSettingsOptionsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var presenter: GameSettingsOptionsPresenterType?

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameOptionCell", for: indexPath)
        
        cell.textLabel?.text = self.presenter?.title(for: indexPath.row)
        cell.detailTextLabel?.text = self.presenter?.description(for: indexPath.row)
        cell.accessoryType = self.presenter?.isSelected(for: indexPath.row) ?? false ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedIndex = self.presenter?.selectedIndex {
            tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0))?.accessoryType = .none
        }
        self.presenter?.select(index: indexPath.row)
        
        // update the checkmark for the current row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.navigationController?.popViewController(animated: true)
    }
}
