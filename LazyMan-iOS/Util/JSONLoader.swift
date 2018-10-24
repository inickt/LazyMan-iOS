//
//  JSONLoader.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/8/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONLoader {
    func load(date: String) -> Result<JSON, StringError>
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
    
    func load(date: String) -> Result<JSON, StringError> {
        guard let url = URL(string: String(format: self.dateFormatURL, date)) else {
            return .failure(StringError("Could not create URL for \(self.dateFormatURL) on \(date)"))
        }
        
        if let jsonData = try? Data(contentsOf: url), let json = try? JSON(data: jsonData) {
            return .success(json)
        }
        else {
            return .failure(StringError("todo")) // TODO: fix error
        }
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
    
    func load(date: String) -> Result<JSON, StringError> {
        guard let filenamePath = Bundle.main.path(forResource: "\(self.filename)", ofType: "json") else {
            return .failure(StringError("File \(self.filename).json does not exist."))
        }
        
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filenamePath)) else {
            return .failure(StringError("File \(self.filename).json could not be loaded."))
        }
        
        guard let json = try? JSON(data: fileData) else {
            return .failure(StringError("Could not parse JSON from \(self.filename)."))
        }
        
        return .success(json)
    }
}
