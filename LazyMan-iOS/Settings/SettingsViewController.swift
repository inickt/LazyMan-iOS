//
//  SettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/26/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController
{
    // MARK: - IBOutlets
    
    @IBOutlet private weak var defaultLeagueControl: UISegmentedControl!
    @IBOutlet private weak var defaultQualityControl: UISegmentedControl!
    @IBOutlet private weak var defaultCDNControl: UISegmentedControl!
    @IBOutlet private weak var favoriteNHLTeamLabel: UILabel!
    @IBOutlet private weak var favoriteMLBTeamLabel: UILabel!
    @IBOutlet private weak var versionUpdatesSwitch: UISwitch!
    @IBOutlet private weak var betaUpdatesSwitch: UISwitch!
    @IBOutlet private weak var betaUpdatesLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.defaultLeagueControl.selectedSegmentIndex = SettingsManager.shared.defaultLeague == .NHL ? 0 : 1
        self.defaultQualityControl.selectedSegmentIndex = SettingsManager.shared.defaultQuality
        self.defaultCDNControl.selectedSegmentIndex = SettingsManager.shared.defaultCDN == .Akamai ? 0 : 1
        self.versionUpdatesSwitch.setOn(SettingsManager.shared.versionUpdates, animated: false)
        self.betaUpdatesSwitch.setOn(SettingsManager.shared.betaUpdates, animated: false)
        self.betaUpdatesSwitch.isEnabled = SettingsManager.shared.versionUpdates
        self.betaUpdatesLabel.isEnabled = SettingsManager.shared.versionUpdates
        self.favoriteNHLTeamLabel.text = SettingsManager.shared.favoriteNHLTeam?.shortName ?? "None"
        self.favoriteMLBTeamLabel.text = SettingsManager.shared.favoriteMLBTeam?.shortName ?? "None"
    }
    
    // MARK: - IBActions
    
    @IBAction private func donePressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func githubPressed(_ sender: Any)
    {
        self.openURL(url: URL(string: "https://github.com/inickt/LazyMan-iOS/")!)
    }
    
    @IBAction private func rLazyManPressed(_ sender: Any)
    {
        self.openURL(url: URL(string: "https://www.reddit.com/r/LazyMan/")!)
    }
    
    @IBAction private func defaultLeaguePressed(_ sender: Any)
    {
        SettingsManager.shared.defaultLeague = self.defaultLeagueControl.selectedSegmentIndex == 0 ? .NHL : .MLB
    }
    
    @IBAction private func defaultQualityPressed(_ sender: Any)
    {
        SettingsManager.shared.defaultQuality = self.defaultQualityControl.selectedSegmentIndex
    }
    
    @IBAction private func defaultCDNPressed(_ sender: Any)
    {
        SettingsManager.shared.defaultCDN = self.defaultCDNControl.selectedSegmentIndex == 0 ? .Akamai : .Level3
    }
    
    @IBAction private func versionUpdatesPressed(_ sender: Any)
    {
        SettingsManager.shared.versionUpdates = self.versionUpdatesSwitch.isOn
        
        if !SettingsManager.shared.versionUpdates
        {
            SettingsManager.shared.betaUpdates = false
            self.betaUpdatesSwitch.setOn(false, animated: true)
        }

        self.betaUpdatesSwitch.isEnabled = SettingsManager.shared.versionUpdates
        self.betaUpdatesLabel.isEnabled = SettingsManager.shared.versionUpdates
    }
    
    @IBAction private func betaUpdatesPressed(_ sender: Any)
    {
        SettingsManager.shared.betaUpdates = self.betaUpdatesSwitch.isOn
    }
    
    // TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 2
        {
            UpdateManager.checkUpdate(completion: self.showMessage, userPressed: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "favoriteNHLSegue", let vc = segue.destination as? SettingsOptionsViewController
        {
            vc.teams = [nil] + Array(TeamManager.nhlTeams.values).sorted { $0.fullName < $1.fullName }
            vc.selectedAction = { (team) in
                self.favoriteNHLTeamLabel.text = team?.shortName ?? "None"
                SettingsManager.shared.favoriteNHLTeam = team
            }
            vc.isFavorite = { $0?.shortName == SettingsManager.shared.favoriteNHLTeam?.shortName }
        }
        else if segue.identifier == "favoriteMLBSegue", let vc = segue.destination as? SettingsOptionsViewController
        {
            vc.teams = [nil] + Array(TeamManager.mlbTeams.values).sorted { $0.fullName < $1.fullName }
            vc.selectedAction = { (team) in
                self.favoriteMLBTeamLabel.text = team?.shortName ?? "None"
                SettingsManager.shared.favoriteMLBTeam = team
            }
            vc.isFavorite = { $0?.shortName == SettingsManager.shared.favoriteMLBTeam?.shortName }
        }
    }
    
    // MARK: - Private
    
    private func openURL(url: URL)
    {
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.openURL(url)
        }
    }
    
    private func showMessage(message: String)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor : UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
        
        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }
}
