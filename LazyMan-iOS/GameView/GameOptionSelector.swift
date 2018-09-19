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
}

class GameOptionSelector<T>: ObjectSelector<T>, AnyGameViewOptionSelector
{
    func getObjects() -> [T]
    {
        return self.objects
    }
}
