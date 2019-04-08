//
//  SingleOptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

final public class SingleOptionSelector<OptionType: Equatable>: ConstrainedOptionSelector {

    public typealias SelectedType = OptionType?

    private(set) public var options: [OptionType]
    public var selected: OptionType? {
        guard let selectedIndex = self.selectedIndex else {
            return nil
        }
        return self.options[selectedIndex]
    }
    private(set) public var selectedIndex: Int?
    public var callback: ((OptionType?) -> Void)?

    public init(_ options: [OptionType], selected: OptionType? = nil, callback: ((OptionType?) -> Void)? = nil) {
        self.options = options
        if let selected = selected {
            self.selectedIndex = options.firstIndex(of: selected)
        }
        self.callback = callback
    }

    public func select(index: Int) {
        guard self.options.indices ~= index else {
            return
        }
        self.selectedIndex = index
    }

    public func select(option: OptionType) {
        guard let index = self.options.firstIndex(where: { $0 == option }) else {
            return
        }
        self.selectedIndex = index
    }

    public func deselect(index: Int) {
        if self.selectedIndex == index {
            self.selectedIndex = nil
        }
    }

    public func deselect(option: OptionType) {
        if self.selected == option {
            self.selectedIndex = nil
        }
    }

    public func isSelected(index: Int) -> Bool {
        return self.selectedIndex == index
    }

    public func isSelected(option: OptionType) -> Bool {
        return self.selected == option
    }
}
