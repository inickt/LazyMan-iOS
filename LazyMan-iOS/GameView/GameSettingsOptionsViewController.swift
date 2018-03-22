//
//  GameSettingsOptionsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameSettingsOptionsViewController: UITableViewController {

    var options = [GameOptionCellText]()
    var selectedIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
