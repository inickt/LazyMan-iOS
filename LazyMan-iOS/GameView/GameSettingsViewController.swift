//
//  GameSettingsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/11/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import OptionSelector

protocol GameSettingsViewControllerType: class {
    func setQuality(text: String?)
    func setFeed(text: String)
    func setCDN(text: String)
}

class GameSettingsViewController: UITableViewController, GameSettingsViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet private var qualityLabel: UILabel!
    @IBOutlet private var feedLabel: UILabel!
    @IBOutlet private var cdnLabel: UILabel!
    @IBOutlet private var qualityCell: UITableViewCell!
    
    // MARK: - Properties
    
    var presenter: GamePresenterType!
    
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

        let vc: UIViewController
        switch indexPath.section {
        case 0:
            guard let selector = presenter?.playlistSelector else {
                return
            }
            vc = DarkOptionViewController(selector)
        case 1:
            guard let selector = presenter?.feedSelector else {
                return
            }
            vc = DarkOptionViewController(selector)
        case 2:
            guard let selector = presenter?.cdnSelector else {
                return
            }
            vc = DarkOptionViewController(selector)
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class DarkOptionViewController<OptionType: OptionSelectorCell>: OptionViewController<OptionType> {

    override func createCell() -> UITableViewCell {
        let cell = super.createCell()
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        return cell
    }

    override var defaultCellStyle: UITableViewCell.CellStyle {
        return .subtitle
    }
}

extension CDN: OptionSelectorCell {
    var description: String {
        return ""
    }

    var image: UIImage? {
        return nil
    }
}

extension Feed: OptionSelectorCell {
    var description: String {
        return ""
    }

    var image: UIImage? {
        return nil
    }
}

extension Playlist: OptionSelectorCell {

    var image: UIImage? {
        return nil
    }
}
