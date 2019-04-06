//
//  GameListTableBackgroundView.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/26/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameListTableBackgroundView: UIView {

    @IBOutlet var errorLabel: UILabel!

    static func instanceFromNib() -> GameListTableBackgroundView {
        // swiftlint:disable:next all
        return UINib(nibName: "GameListTableBackgroundView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GameListTableBackgroundView
    }
}
