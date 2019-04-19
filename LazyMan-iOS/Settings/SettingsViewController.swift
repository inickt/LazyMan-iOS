//
//  SettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/26/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import OptionSelector

protocol SettingsViewType: AnyObject {
    func showNHLTeams(text: String)
    func showMLBTeams(text: String)
    func showDefault(league: League)
    func showDefault(quality: Quality)
    func showDefault(cdn: CDN)
    func showPreferFrench(isOn: Bool)
    func showVersionUpdates(isOn: Bool)
    func showBetaUpdates(isOn: Bool, enabled: Bool)
    func open(url: URL)
    func show(message: String)
}

private let kGameSection = 0
private let kFavoriteSection = 1
private let kUpdateSection = 2
private let kFavoriteNHLIndex = 0
private let kFavoriteMLBIndex = 1
private let kCheckUpdateIndex = 2

class SettingsViewController: UITableViewController, SettingsViewType {

    // MARK: - IBOutlets

    @IBOutlet private var defaultLeagueControl: UISegmentedControl!
    @IBOutlet private var defaultQualityControl: UISegmentedControl!
    @IBOutlet private var defaultCDNControl: UISegmentedControl!
    @IBOutlet private var preferFrenchSwitch: UISwitch!
    @IBOutlet private var favoriteNHLTeamLabel: UILabel!
    @IBOutlet private var favoriteMLBTeamLabel: UILabel!
    @IBOutlet private var versionUpdatesSwitch: UISwitch!
    @IBOutlet private var betaUpdatesSwitch: UISwitch!
    @IBOutlet private var betaUpdatesLabel: UILabel!

    // MARK: - Properties

    var presenter: SettingsPresenterType?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.showDefaults()
    }

    // MARK: - SettingsViewType

    func showNHLTeams(text: String) {
        self.favoriteNHLTeamLabel.text = text
    }

    func showMLBTeams(text: String) {
        self.favoriteMLBTeamLabel.text = text
    }

    func showDefault(league: League) {
        self.defaultLeagueControl.selectedSegmentIndex = league == .NHL ? 0 : 1
    }

    func showDefault(quality: Quality) {
        self.defaultQualityControl.selectedSegmentIndex = quality == .auto ? 0 : 1
    }

    func showDefault(cdn: CDN) {
        self.defaultCDNControl.selectedSegmentIndex = cdn == .akamai ? 0 : 1
    }

    func showPreferFrench(isOn: Bool) {
        self.preferFrenchSwitch.setOn(isOn, animated: true)
    }

    func showVersionUpdates(isOn: Bool) {
        self.versionUpdatesSwitch.setOn(isOn, animated: true)
    }

    func showBetaUpdates(isOn: Bool, enabled: Bool) {
        self.betaUpdatesSwitch.setOn(isOn, animated: true)
        self.betaUpdatesSwitch.isEnabled = enabled
        self.betaUpdatesLabel.isEnabled = enabled
    }

    func open(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func show(message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)

        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor: UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")

        self.present(alert, animated: true, completion: nil)

        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case kGameSection:
            return
        case kFavoriteSection:
            let viewController: DarkOptionViewController<Team>
            switch indexPath.row {
            case kFavoriteNHLIndex:
                guard let selector = self.presenter?.favoriteNHLTeamSelector else {
                    return
                }
                viewController = DarkOptionViewController(selector)
            case kFavoriteMLBIndex:
                guard let selector = self.presenter?.favoriteMLBTeamSelector else {
                    return
                }
                viewController = DarkOptionViewController(selector)
            default:
                return
            }
            viewController.popOnSelection = false
            viewController.title? = "Favorite Teams"
            self.navigationController?.pushViewController(viewController, animated: true)
        case kUpdateSection:
            if indexPath.row == kCheckUpdateIndex {
                self.presenter?.updatePressed()
            }
        default:
            return
        }
    }

    // MARK: - IBActions

    @IBAction private func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction private func githubPressed(_ sender: Any) {
        self.presenter?.githubPressed()
    }

    @IBAction private func rLazyManPressed(_ sender: Any) {
        self.presenter?.rLazyManPressed()
    }

    @IBAction private func defaultLeaguePressed(_ sender: Any) {
        self.presenter?.setDefault(league: self.defaultLeagueControl.selectedSegmentIndex == 0 ? .NHL : .MLB)
    }

    @IBAction private func defaultQualityPressed(_ sender: Any) {
        self.presenter?.setDefault(quality: self.defaultQualityControl.selectedSegmentIndex == 0 ? .auto : .best)
    }

    @IBAction private func defaultCDNPressed(_ sender: Any) {
        self.presenter?.setDefault(cdn: self.defaultCDNControl.selectedSegmentIndex == 0 ? .akamai : .level3)
    }

    @IBAction private func preferFrenchPressed(_ sender: Any) {
        self.presenter?.setPreferFrench(enabled: self.preferFrenchSwitch.isOn)
    }

    @IBAction private func versionUpdatesPressed(_ sender: Any) {
        self.presenter?.setVersionUpdates(enabled: self.versionUpdatesSwitch.isOn)
    }

    @IBAction private func betaUpdatesPressed(_ sender: Any) {
        self.presenter?.setBetaUpdates(enabled: self.betaUpdatesSwitch.isOn)
    }
}
