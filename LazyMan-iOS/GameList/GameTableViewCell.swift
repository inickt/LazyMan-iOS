//
//  GameTableViewCell.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet private var awayTeamImage: UIImageView!
    @IBOutlet private var homeTeamImage: UIImageView!
    @IBOutlet private var awayTeamLabel: UILabel!
    @IBOutlet private var homeTeamLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    var game: Game? {
        didSet {
            self.awayTeamImage.image = self.game?.awayTeam.logo
            self.homeTeamImage.image = self.game?.homeTeam.logo
            self.awayTeamLabel.text = self.game?.awayTeam.name
            self.homeTeamLabel.text = self.game?.homeTeam.name
            self.timeLabel.text = self.game?.gameStateDescription

            // TODO: Bad singleton access?
            if let game = self.game, TeamManager.shared.hasFavoriteTeam(game: game) {
                self.backgroundColor = UIColor(red: 0.0, green: 0.07, blue: 0.14, alpha: 1.0)
            } else {
                self.backgroundColor = .black
            }
        }
    }
}
