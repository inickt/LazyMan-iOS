//
//  DarkOptionViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/7/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import UIKit
import OptionSelector

class DarkOptionViewController<OptionType: OptionSelectorCell>: OptionViewController<OptionType> {

    override func styleView() {
        self.view.backgroundColor = .black
        self.tableView.tableFooterView = UIView()
    }

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
