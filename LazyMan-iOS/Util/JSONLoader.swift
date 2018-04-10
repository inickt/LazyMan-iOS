//
//  JSONLoader.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/8/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

protocol JSONLoader
{
    func load(completion: (Data) -> (), error: ((String) -> ())?)
}

class JSONWebLoader: JSONLoader
{
    let url: URL
    
    init(url: URL)
    {
        self.url = url
    }
    
    
    func load(completion: (Data) -> (), error: ((String) -> ())?)
    {
        
    }
}

class JSONFileLoader: JSONLoader
{
    let fileURL: URL
    
    init(fileURL: URL)
    {
        self.fileURL = fileURL
    }
    
    func load(completion: (Data) -> (), error: ((String) -> ())?)
    {
        
    }
}
