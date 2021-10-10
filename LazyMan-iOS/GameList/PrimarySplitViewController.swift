//
//  PrimarySplitViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 10/10/21.
//  Copyright © 2021 Nick Thompson. All rights reserved.
//

import UIKit

class PrimarySplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    internal var collapseDetailViewController = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return self.collapseDetailViewController
    }

    @available(iOS 14.0, *)
    public func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
