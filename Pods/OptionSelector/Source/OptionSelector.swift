//
//  OptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

public protocol OptionSelector {

    associatedtype OptionType: Equatable

    var options: [OptionType] { get }
    subscript(index: Int) -> OptionType { get }

    func select(index: Int)
    func select(option: OptionType)
    func deselect(index: Int)
    func deselect(option: OptionType)
    func toggle(index: Int)
    func toggle(option: OptionType)
    func isSelected(index: Int) -> Bool
    func isSelected(option: OptionType) -> Bool
}

public extension OptionSelector {

    subscript(index: Int) -> OptionType {
        return self.options[index]
    }

    func toggle(index: Int) {
        if self.isSelected(index: index) {
            self.deselect(index: index)
        } else {
            self.select(index: index)
        }
    }

    func toggle(option: OptionType) {
        if self.isSelected(option: option) {
            self.deselect(option: option)
        } else {
            self.select(option: option)
        }
    }
}
