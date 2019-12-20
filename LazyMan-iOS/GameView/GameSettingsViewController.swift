//
//  GameSettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import OptionSelector

private let kPlaylistIndex = 0
private let kFeedIndex = 1
private let kCDNIndex = 2

class GameSettingsViewController: UITableViewController {

    // MARK: - IBOutlets

    @IBOutlet private var qualityLabel: UILabel!
    @IBOutlet private var feedLabel: UILabel!
    @IBOutlet private var cdnLabel: UILabel!
    @IBOutlet private var qualityCell: UITableViewCell!

    // MARK: - Properties

    var presenter: GamePresenterType?

    // MARK: - Public

    func setQuality(text: String?) {
        if let text = text {
            self.qualityCell.accessoryView = nil
            self.qualityCell.accessoryType = .disclosureIndicator
            self.qualityLabel.text = text
        } else {
            self.qualityLabel.text = ""
            self.qualityCell.accessoryType = .none
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            activityIndicator.startAnimating()
            self.qualityCell.accessoryView = activityIndicator
        }
    }

    func setFeed(text: String) {
        self.feedLabel.text = text
    }

    func setCDN(text: String) {
        self.cdnLabel.text = text
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController: UIViewController
        switch indexPath.section {
        case kPlaylistIndex:
            guard let selector = presenter?.playlistSelector else {
                return
            }
            viewController = DarkOptionViewController(selector, style: .grouped)
            viewController.title = "Quality"
        case kFeedIndex:
            guard let selector = presenter?.feedSelector else {
                return
            }
            viewController = DarkOptionViewController(selector, style: .grouped)
            viewController.title = "Feed"
        case kCDNIndex:
            guard let selector = presenter?.cdnSelector else {
                return
            }
            viewController = DarkOptionViewController(selector, style: .grouped)
            viewController.title = "CDN"
        default:
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
