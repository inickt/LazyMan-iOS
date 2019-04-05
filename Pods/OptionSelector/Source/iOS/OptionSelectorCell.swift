//
//  OptionSelectorCell.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import UIKit

public protocol OptionSelectorCell: Equatable {

    var title: String { get }
    var description: String { get }
    var image: UIImage? { get }
}
