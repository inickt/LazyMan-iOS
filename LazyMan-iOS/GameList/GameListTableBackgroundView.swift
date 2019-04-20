//
//  GameListTableBackgroundView.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/26/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameListTableBackgroundView: UIView {

    // MARK: - IBOutlets

    @IBOutlet private var errorLabel: UILabel!

    // MARK: - Properties

    var errorMessage: String? {
        set {
            self.errorLabel.text = newValue
        }
        get {
            return self.errorLabel.text
        }
    }

    static func instanceFromNib() -> GameListTableBackgroundView {
        // swiftlint:disable:next all
        return UINib(nibName: "GameListTableBackgroundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GameListTableBackgroundView
    }
}
