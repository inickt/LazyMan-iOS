//
//  ObjectSelector.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/5/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

/*
 * Represents an object which can hold an array of items and maintain a selected element in the array.
 */
protocol AnyObjectSelector
{
    associatedtype ObjectType
    
    var objects: [ObjectType] { get }
    var selectedIndex: Int? { get }
    var selectedObject: ObjectType? { get }
    var count: Int { get }
    var onSelection: ((ObjectType) -> ())? { get set }
    
    func select(index: Int)
}

/*
 * Can hold a non-mutable array and keeps track of a currently selected element.
 */
class ObjectSelector<T>: AnyObjectSelector
{
    let objects: [T]
    var onSelection: ((T) -> ())?
    private var selected: Int?
    
    var selectedIndex: Int?
    {
        return selected
    }
    
    var selectedObject: T?
    {
        guard let selected = self.selected else { return nil }
        return self.objects[selected]
    }
    
    var count: Int
    {
        return self.objects.count
    }
    
    init(objects: [T])
    {
        self.objects = objects
    }
    
    func select(index: Int)
    {
        guard index < self.objects.count else { return }
        self.selected = index
        self.onSelection?(self.objects[index])
    }
}
