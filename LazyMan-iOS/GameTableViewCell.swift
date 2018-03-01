//
//  GameTableViewCell.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var awayTeamImage: UIImageView!
    @IBOutlet weak var homeTeamImage: UIImageView!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var game: Game?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateGameInfo(game: Game) {
        self.game = game
        
        self.awayTeamImage.image = self.game?.awayTeam.logo
        self.homeTeamImage.image = self.game?.homeTeam.logo
        self.awayTeamLabel.text = self.game?.awayTeam.fullName
        self.homeTeamLabel.text = self.game?.homeTeam.fullName
        
        self.timeLabel.text = self.game?.time
    }
}
