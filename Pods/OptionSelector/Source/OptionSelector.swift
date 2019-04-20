//
//  OptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

/// Interface for selecting objects based on index or reference.
public protocol OptionSelector {

    /// Type of the options to be able to select.
    associatedtype OptionType: Equatable

    /// Array of options that can be selected.
    var options: [OptionType] { get }

    /// Shortcut to get the item at the given index in the array of options.
    ///
    /// - Parameter index: Index of element to return. Must be within array bounds.
    subscript(index: Int) -> OptionType { get }

    /// Select the given index in the options.
    func select(index: Int)

    /// Select the option in the options array.
    ///
    /// Based on the `OptionType`s `Equatable` implementation.
    /// - Parameter option: Option to select
    func select(option: OptionType)

    /// Deselect the given index in the options.
    func deselect(index: Int)

    /// Deelect the option in the options array.
    ///
    /// Based on the `OptionType`s `Equatable` implementation.
    /// - Parameter option: Option to deselect
    func deselect(option: OptionType)

    /// Toggles the selected state of the given index in the options.
    func toggle(index: Int)

    /// Toggle the option in the array.
    ///
    /// Based on the `OptionType`s `Equatable` implementation.
    /// - Parameter option: Option to toggle
    func toggle(option: OptionType)

    /// Is the given index selected?
    func isSelected(index: Int) -> Bool

    /// Is the given option selected?
    func isSelected(option: OptionType) -> Bool
}

public extension OptionSelector {

    subscript(index: Int) -> OptionType {
        return self.options[index]
    }

    /// Based on implementation of `isSelected:index`, `deselect:index`, and`select:index`.
    ///
    /// If `isSelected:index`, then `deselect:index` is called, otherwise `select:index` is called.
    func toggle(index: Int) {
        if self.isSelected(index: index) {
            self.deselect(index: index)
        } else {
            self.select(index: index)
        }
    }

    /// Based on implementation of `isSelected:option`, `deselect:option`, and`select:option`.
    ///
    /// If `isSelected:option`, then `deselect:option` is called, otherwise `select:option` is called.
    func toggle(option: OptionType) {
        if self.isSelected(option: option) {
            self.deselect(option: option)
        } else {
            self.select(option: option)
        }
    }
}
