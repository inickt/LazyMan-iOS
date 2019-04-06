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
    func load(date: String) -> Result<JSON, JSONLoaderError>
}

enum JSONLoaderError: LazyManError {

    var messgae: String {
        switch self {
        case .fileError(let filename):
            return "File \(filename).json does not exist."
        case .urlError(let description):
            return "Could not create url from \(description) to parse JSON."
        case .dataError(let source):
            return "Could not load data from \(source) to parse JSON."
        case .parseError(let source):
            return "Could not parse JSON from \(source)."
        }
    }

    case fileError(String), urlError(String), dataError(String), parseError(String)
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

    func load(date: String) -> Result<JSON, JSONLoaderError> {
        guard let url = URL(string: String(format: self.dateFormatURL, date)) else {
            return .failure(.urlError("\(date) schedule"))
        }

        // TODO: Bring back URLSession (had better error messages)
        guard let jsonData = try? Data(contentsOf: url) else {
            return .failure(.dataError("\(date) schedule"))
        }

        guard let json = try? JSON(data: jsonData) else {
            return .failure(.parseError("\(date) schedule"))
        }

        return .success(json)
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

    func load(date: String) -> Result<JSON, JSONLoaderError> {
        guard let filenamePath = Bundle.main.path(forResource: "\(self.filename)", ofType: "json") else {
            return .failure(.fileError(self.filename))
        }

        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: filenamePath)) else {
            return .failure(.dataError("File \(self.filename).json could not be loaded."))
        }

        guard let json = try? JSON(data: fileData) else {
            return .failure(.parseError("Could not parse JSON from \(self.filename)."))
        }

        return .success(json)
    }
}
