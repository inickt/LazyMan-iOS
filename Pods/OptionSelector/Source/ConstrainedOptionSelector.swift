//
//  ConstrainedOptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 4/4/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

public protocol ConstrainedOptionSelector: OptionSelector {

    associatedtype SelectedType

    var selected: SelectedType { get }
    var callback: ((SelectedType) -> Void)? { get set }
}
