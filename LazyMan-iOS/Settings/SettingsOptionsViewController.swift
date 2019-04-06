//
//  SettingsOptionsViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 5/12/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class SettingsOptionsViewController: UITableViewController {

    var teams: [Team?]?
    var selectedAction: ((Team?) -> Void)?
    var isFavorite: ((Team?) -> Bool)?
    private var blankImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .black
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0.0)
        self.blankImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsOptionCell", for: indexPath)

        if let teams = self.teams, indexPath.row < teams.count {
            if let team = teams[indexPath.row] {
                cell.textLabel?.text = team.name
                cell.imageView?.image = team.logo.addImagePadding(xPadding: 90, yPadding: 90)
                cell.accessoryType = self.isFavorite?(team) ?? false ? .checkmark : .none
            } else {
                cell.imageView?.image = self.blankImage
                cell.textLabel?.text = "None"
                cell.accessoryType = self.isFavorite?(nil) ?? false ? .checkmark : .none
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let teams = self.teams, indexPath.row < teams.count {
            self.selectedAction?(teams[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
}

private extension UIImage {

    func addImagePadding(xPadding: CGFloat, yPadding: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + xPadding
        let height: CGFloat = size.height + yPadding
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithPadding
    }
}
