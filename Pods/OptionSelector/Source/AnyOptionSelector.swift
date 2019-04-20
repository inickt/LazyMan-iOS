//
//  AnyOptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

public struct AnyOptionSelector<OptionType: Equatable>: OptionSelector {

    private let _options: () -> ([OptionType])
    private let _selectIndex: (Int) -> Void
    private let _selectOption: (OptionType) -> Void
    private let _deselectIndex: (Int) -> Void
    private let _deselectOption: (OptionType) -> Void
    private let _toggleIndex: (Int) -> Void
    private let _toggleOption: (OptionType) -> Void
    private let _isSelectedIndex: (Int) -> Bool
    private let _isSelectedOption: (OptionType) -> Bool

    public init<Selector: OptionSelector>(_ selector: Selector) where Selector.OptionType == OptionType {
        self._options = { selector.options }
        self._selectIndex = selector.select
        self._selectOption = selector.select
        self._deselectIndex = selector.deselect
        self._deselectOption = selector.deselect
        self._toggleIndex = selector.toggle
        self._toggleOption = selector.toggle
        self._isSelectedIndex = selector.isSelected
        self._isSelectedOption = selector.isSelected
    }

    public var options: [OptionType] {
        return self._options()
    }

    public func select(index: Int) {
        self._selectIndex(index)
    }

    public func select(option: OptionType) {
        self._selectOption(option)
    }

    public func deselect(index: Int) {
        self._deselectIndex(index)
    }

    public func deselect(option: OptionType) {
        self._deselectOption(option)
    }

    public func isSelected(index: Int) -> Bool {
        return self._isSelectedIndex(index)
    }

    public func isSelected(option: OptionType) -> Bool {
        return self._isSelectedOption(option)
    }
}
