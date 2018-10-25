//
//  GameSettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol GameSettingsViewControllerType: class
{
    func setQuality(text: String?)
    func setFeed(text: String)
    func setCDN(text: String)
}

class GameSettingsViewController: UITableViewController, GameSettingsViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet private weak var qualityLabel: UILabel!
    @IBOutlet private weak var feedLabel: UILabel!
    @IBOutlet private weak var cdnLabel: UILabel!
    @IBOutlet private weak var qualityCell: UITableViewCell!
    
    // MARK: - Properties
    
    var presenter: GamePresenterType!
    
    // MARK: - Navigation
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
//    {
//        return !(identifier == "gameOptionQuality" && self.presenter.qualitySelector == nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier
        {
            
            
            switch id
            {
            case "gameOptionCDN":
                segue.destination.title = "CDN"
                let settingsOptions = segue.destination as? GameSettingsOptionsViewController<CDN>
                settingsOptions?.optionSelector = ObjectSelector(objects: [.Akamai, .Level3])
//                settingsOptions?.opetionSelector = self.presenter.cdnSelector
                
            case "gameOptionQuality":
                segue.destination.title = "Quality"
//                settingsOptions?.opetionSelector = self.presenter.qualitySelector
                
            case "gameOptionFeed":
                segue.destination.title = "Feed"
//                settingsOptions?.opetionSelector = self.presenter.feedSelector
                
            default:
                return
            }
        }
    }
    
    // MARK: - GameSettingsViewControllerType
    
    func setQuality(text: String?)
    {
        if let text = text
        {
            self.qualityCell.accessoryView = nil
            self.qualityCell.accessoryType = .disclosureIndicator
            self.qualityLabel.text = text
        }
        else
        {
            self.qualityLabel.text = ""
            self.qualityCell.accessoryType = .none
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.startAnimating()
            self.qualityCell.accessoryView = activityIndicator
        }
    }
    
    func setFeed(text: String)
    {
        self.feedLabel.text = text
    }
    
    func setCDN(text: String)
    {
        self.cdnLabel.text = text
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
