//
//  SingularOptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

public final class SingularOptionSelector<OptionType: Equatable>: ConstrainedOptionSelector {

    public typealias SelectedType = OptionType

    public private(set) var options: [OptionType]
    public private(set) var selectedIndex: Int {
        didSet {
            self.callback?(self.selected)
        }
    }

    public var selected: OptionType {
        return self.options[selectedIndex]
    }
    public var callback: ((OptionType) -> Void)?

    public init?(_ options: [OptionType], selected: OptionType, callback: ((OptionType) -> Void)? = nil) {
        guard !options.isEmpty, let selectedIndex = options.firstIndex(of: selected) else {
            return nil
        }
        self.options = options
        self.selectedIndex = selectedIndex
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

    public func deselect(index: Int) { }

    public func deselect(option: OptionType) { }

    public func isSelected(index: Int) -> Bool {
        return self.selectedIndex == index
    }

    public func isSelected(option: OptionType) -> Bool {
        return self.selected == option
    }
}
