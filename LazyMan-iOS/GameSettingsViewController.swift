//
//  GameSettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameSettingsViewController: UITableViewController
{
    var game: Game!
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let id = segue.identifier
        {
            let settingsOptions = segue.destination as? GameSettingsOptionsViewController
            
            switch id
            {
            case "gameOptionCDN":
                settingsOptions?.options = [CDN.Akamai, CDN.Level3]
                break
                
            case "gameOptionQuality":
                settingsOptions?.options = [CDN.Akamai, CDN.Level3]
                break
                
            case "gameOptionFeed":
                settingsOptions?.options = self.game.feeds
                break
            default:
                return
            }
        }
    }

}
