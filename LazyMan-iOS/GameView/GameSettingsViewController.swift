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
    func setQuality(text: String)
    func setFeed(text: String)
    func setCDN(text: String)
}

class GameSettingsViewController: UITableViewController, GameSettingsViewControllerType
{
    @IBOutlet private weak var qualityLabel: UILabel!
    @IBOutlet private weak var feedLabel: UILabel!
    @IBOutlet private weak var cdnLabel: UILabel!
    @IBOutlet weak var qualityCell: UITableViewCell!
    
    var presenter: GameViewPresenterType!
    
    // MARK: - Navigation

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setCDN(text: self.presenter.cdnSelector.getSelected()?.getTitle() ?? "")
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let id = segue.identifier
        {
            let settingsOptions = segue.destination as? GameSettingsOptionsViewController
            
            settingsOptions?.refreshControl = UIRefreshControl()
            settingsOptions?.refreshControl?.beginRefreshing()
            settingsOptions?.refreshControl?.backgroundColor = UIColor.darkGray
            
            switch id
            {
            case "gameOptionCDN":
//                self.presenter.getCDNOptions(completion: { (cdnOptions) in
//                    settingsOptions?.refreshControl?.endRefreshing()
//                    settingsOptions?.options = cdnOptions
//
//
//                }, error: {
//
//                })
//                settingsOptions?.title = "CDN"
//                settingsOptions?.option = .optionCDN
                settingsOptions?.opetionSelector = self.presenter.cdnSelector
                
                
                
            case "gameOptionQuality":
                self.presenter.getPlaylistOptions(completion: { (playlistOptions) in
                    settingsOptions?.options = playlistOptions
                    settingsOptions?.refreshControl?.endRefreshing()
                }, error: {
                    
                })
                settingsOptions?.title = "Quality"
                settingsOptions?.option = .optionQuality
                
            case "gameOptionFeed":
                self.presenter.getFeedOptions(completion: { (feedOptions) in
                    settingsOptions?.options = feedOptions
                }, error: {
                    
                })
                settingsOptions?.title = "Feed"
                settingsOptions?.option = .optionFeed
                
            default:
                return
            }
        }
    }
    
    func setQuality(text: String)
    {
        self.qualityLabel.text = text
        self.tableView.reloadData()
    }
    
    func setFeed(text: String)
    {
        self.feedLabel.text = text
        self.tableView.reloadData()
    }
    
    func setCDN(text: String)
    {
        self.cdnLabel.text = text
        self.tableView.reloadData()
    }
}
