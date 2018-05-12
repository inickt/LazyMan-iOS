//
//  GameTableViewCell.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell
{
    @IBOutlet private weak var awayTeamImage: UIImageView!
    @IBOutlet private weak var homeTeamImage: UIImageView!
    @IBOutlet private weak var awayTeamLabel: UILabel!
    @IBOutlet private weak var homeTeamLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    var game: Game?
    {
        didSet
        {
            self.awayTeamImage.image = self.game?.awayTeam.logo
            self.homeTeamImage.image = self.game?.homeTeam.logo
            self.awayTeamLabel.text = self.game?.awayTeam.fullName
            self.homeTeamLabel.text = self.game?.homeTeam.fullName
            self.timeLabel.text = self.game?.getGameState()
        }
    }
}
