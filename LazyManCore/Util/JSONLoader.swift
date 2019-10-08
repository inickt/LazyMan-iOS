//
//  JSONLoader.swift
//  LazyManCore
//
//  Created by Nick Thompson on 4/8/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONLoader {
    func load(date: String) -> Result<JSON, JSONLoaderError>
}

public enum JSONLoaderError: LazyManError {

    public var messgae: String {
        switch self {
        case .fileError(let filename):
            return "File \(filename).json does not exist."
        case .urlError(let description):
            return "Could not create url from \(description) to parse JSON."
        case .loadError(let message):
            return message
        case .dataError(let source):
            return "Could not load data from \(source) to parse JSON."
        case .parseError(let source):
            return "Could not parse JSON from \(source)."
        }
    }

    case fileError(String), urlError(String), loadError(String), dataError(String), parseError(String)
}

public class JSONWebLoader: JSONLoader {

    // MARK: - Private

    private let dateFormatURL: String
    private let session: URLSession

    // MARK: - Initialization

    public init(dateFormatURL: String) {
        self.dateFormatURL = dateFormatURL
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.session = URLSession(configuration: config)
    }

    // MARK: - JSONLoader

    public func load(date: String) -> Result<JSON, JSONLoaderError> {
        guard let url = URL(string: String(format: self.dateFormatURL, date)) else {
             return .failure(.urlError("\(date) schedule"))
        }

        let (data, _, error) = URLSession.shared.synchronousDataTask(with: url)

        guard let jsonData = data else {
            if let errorMessage = error?.localizedDescription {
                return .failure(.loadError(errorMessage))
            }
            return .failure(.dataError("\(date) schedule"))
        }

        guard let json = try? JSON(data: jsonData) else {
            return .failure(.parseError("\(date) schedule"))
        }

        return .success(json)
    }
}

public class JSONFileLoader: JSONLoader {

    // MARK: - Private

    private let filename: String

    // MARK: - Initialization

    public init(filename: String) {
        self.filename = filename
    }

    // MARK: - JSONLoader

    public func load(date: String) -> Result<JSON, JSONLoaderError> {
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
