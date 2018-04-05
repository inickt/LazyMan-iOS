//
//  GameViewOptionSelector.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/2/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class GameViewOptionSelector<T>
{
    let objects: [T]
    private var index: Int?
    
    init(objects: [T])
    {
        self.objects = objects
    }
    
    func getSelected() -> T?
    {
        guard let index = index else { return nil }
        
        return self.objects[index]
    }
    
    func getSelectedIndex() -> Int?
    {
        return self.index
    }
    
    func selectOption(index: Int)
    {
        self.index = index
    }
}
