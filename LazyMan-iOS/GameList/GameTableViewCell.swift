//
//  GameTableViewCell.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/23/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import LazyManCore

class GameTableViewCell: UITableViewCell {

    @IBOutlet private var awayTeamImage: UIImageView!
    @IBOutlet private var homeTeamImage: UIImageView!
    @IBOutlet private var awayTeamLabel: UILabel!
    @IBOutlet private var homeTeamLabel: UILabel!
    @IBOutlet private var awayTeamScoreLabel: UILabel!
    @IBOutlet private var homeTeamScoreLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    var game: Game? {
        didSet {
            self.awayTeamImage.image = self.game?.awayTeam.logo
            self.homeTeamImage.image = self.game?.homeTeam.logo
            self.awayTeamLabel.text = self.game?.awayTeam.teamName
            self.homeTeamLabel.text = self.game?.homeTeam.teamName
            if let awayScore = self.game?.awayTeamScore, SettingsManager.shared.showScores {
                self.awayTeamScoreLabel.text = "\(awayScore)"
            } else {
                self.awayTeamScoreLabel.text = nil
            }
            if let homeScore = self.game?.homeTeamScore, SettingsManager.shared.showScores {
                self.homeTeamScoreLabel.text = "\(homeScore)"
            } else {
                self.homeTeamScoreLabel.text = nil
            }
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
