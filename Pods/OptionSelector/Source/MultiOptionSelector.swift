//
//  MultiOptionSelector.swift
//  OptionSelector
//
//  Created by Nick Thompson on 3/31/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

final public class MultiOptionSelector<OptionType: Equatable>: ConstrainedOptionSelector {

    public typealias SelectedType = [OptionType]

    private(set) public var options: [OptionType]
    public var selected: [OptionType] {
        return selectedIndices.map { self.options[$0] }
    }
    private(set) public var selectedIndices: Set<Int> {
        didSet {
            self.callback?(self.selected)
        }
    }
    public var callback: (([OptionType]) -> Void)?

    public init(_ options: [OptionType], selected: [OptionType] = [], callback: (([OptionType]) -> Void)? = nil) {
        self.options = options
        self.selectedIndices = Set(selected.flatMap { sel in options.indices.filter { options[$0] == sel } })
        self.callback = callback
    }

    public func select(index: Int) {
        guard self.options.indices ~= index else {
            return
        }
        self.selectedIndices.insert(index)
    }

    public func select(option: OptionType) {

    }

    public func deselect(index: Int) {

    }

    public func deselect(option: OptionType) {

    }

    public func isSelected(index: Int) -> Bool {
        return self.selectedIndices.contains(index)
    }

    public func isSelected(option: OptionType) -> Bool {
        return self.selected.contains(option)
    }
}
