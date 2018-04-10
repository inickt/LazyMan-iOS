//
//  GameOptionSelector.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/2/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

protocol AnyGameViewOptionSelector
{
    var selectedIndex: Int? { get }
    var count: Int { get }
    func select(index: Int)
    func getObjects() -> [GameOptionCellText]
}

class GameOptionSelector<T: GameOptionCellText>: ObjectSelector<T>, AnyGameViewOptionSelector
{
    func getObjects() -> [GameOptionCellText]
    {
        return self.objects
    }
}
