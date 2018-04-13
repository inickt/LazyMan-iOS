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
    func load(date: String, completion: @escaping (Data) -> (), error: ((String) -> ())?)
}

class JSONWebLoader: JSONLoader
{
    private let dateFormatURL: String
    private let session: URLSession
    
    init(dateFormatURL: String)
    {
        self.dateFormatURL = dateFormatURL
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.session = URLSession(configuration: config)
    }
    
    func load(date: String, completion: @escaping (Data) -> (), error: ((String) -> ())?)
    {
        guard let url = URL(string: String(format: self.dateFormatURL, date)) else
        {
            error?("Could not create URL for \(self.dateFormatURL) on \(date)")
            return
        }
        
        self.session.dataTask(with: url) { (taskData, taskResponse, taskError) in
            guard let taskData = taskData else
            {
                if let taskError = taskError
                {
                    error?(taskError.localizedDescription)
                }
                else
                {
                    error?("Unknown error loading data from \(url.absoluteString)")
                }
                return
            }
            
            completion(taskData)
        }.resume()
    }
}

class JSONFileLoader: JSONLoader
{
    private let filename: String
    
    init(filename: String)
    {
        self.filename = filename
    }
    
    func load(date: String, completion: @escaping (Data) -> (), error: ((String) -> ())?)
    {
        guard let filenamePath = Bundle.main.path(forResource: "\(self.filename)", ofType: "json") else
        {
            error?("File \(self.filename).json does not exist.")
            return
        }
        
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filenamePath)) else
        {
            error?("File \(self.filename).json could not be loaded.")
            return
        }
        
        completion(fileData)
    }
}
