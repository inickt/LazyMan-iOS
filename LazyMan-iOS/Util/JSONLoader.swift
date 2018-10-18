//
//  JSONLoader.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/8/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

protocol JSONLoader {
    func load(date: String, completion: @escaping ((Result<Data, StringError>) -> ()))
}

class JSONWebLoader: JSONLoader {
    
    // MARK: - Private
    
    private let dateFormatURL: String
    private let session: URLSession
    
    // MARK: - Initialization
    
    init(dateFormatURL: String) {
        self.dateFormatURL = dateFormatURL
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - JSONLoader
    
    func load(date: String, completion: @escaping ((Result<Data, StringError>) -> ())) {
        guard let url = URL(string: String(format: self.dateFormatURL, date)) else {
            completion(.failure(StringError("Could not create URL for \(self.dateFormatURL) on \(date)")))
            return
        }
        
        self.session.dataTask(with: url) { (taskData, taskResponse, taskError) in
            guard let taskData = taskData else {
                if let taskError = taskError {
                    completion(.failure(StringError(taskError.localizedDescription)))
                }
                else {
                    completion(.failure(StringError(("Unknown error loading data from \(url.absoluteString)"))))
                }
                return
            }
            
            completion(.success(taskData))
        }.resume()
    }
}

class JSONFileLoader: JSONLoader {
    
    // MARK: - Private
    
    private let filename: String
    
    // MARK: - Initialization
    
    init(filename: String) {
        self.filename = filename
    }
    
    // MARK: - JSONLoader
    
    func load(date: String, completion: @escaping ((Result<Data, StringError>) -> ())) {
        guard let filenamePath = Bundle.main.path(forResource: "\(self.filename)", ofType: "json") else {
            completion(.failure(StringError("File \(self.filename).json does not exist.")))
            return
        }
        
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filenamePath)) else {
            completion(.failure(StringError("File \(self.filename).json could not be loaded.")))
            return
        }
        
        completion(.success(fileData))
    }
}
