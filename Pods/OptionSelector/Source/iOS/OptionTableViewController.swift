//
//  OptionTableViewController.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import UIKit

open class OptionViewController<OptionType: OptionSelectorCell>: UITableViewController {

    public var selector: AnyOptionSelector<OptionType>
    public var popOnSelection = true

    public convenience init<Selector: OptionSelector>(_ selector: Selector) where Selector.OptionType == OptionType {
        self.init(selector: AnyOptionSelector(selector))
    }

    public init(selector: AnyOptionSelector<OptionType>) {
        self.selector = selector
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented.")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selector.options.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.createCell()

        cell.textLabel?.text = self.selector[indexPath.row].title
        cell.detailTextLabel?.text = self.selector[indexPath.row].description
        cell.imageView?.image = self.selector[indexPath.row].image
        cell.accessoryType = self.selector.isSelected(index: indexPath.row) ? .checkmark : .none

        return cell
    }

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        self.selector.toggle(index: indexPath.row)
        self.tableView.reloadData()
        if popOnSelection {
            self.navigationController?.popViewController(animated: true)
        }
    }

    open var defaultCellStyle: UITableViewCell.CellStyle {
        return .default
    }

    open func styleView() { }

    open func createCell() -> UITableViewCell {
        let cellIdentifier = "DefaultOptionSelectorCell"
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
            UITableViewCell(style: self.defaultCellStyle, reuseIdentifier: cellIdentifier)
    }
}
