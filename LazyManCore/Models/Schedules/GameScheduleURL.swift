//
//  GameScheduleURL.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/8/20.
//

import Foundation

protocol MLBAMScheduleURL {
    func gameScheduleURL(for date: String) -> URL?
    func gameScheduleURL(from startDate: String, to endDate: String) -> URL?
    var gameScheduleComponents: URLComponents? { get }
}

extension MLBAMScheduleURL {
    func gameScheduleURL(for date: String) -> URL? {
        return gameScheduleURL(from: date, to: date)
    }

    func gameScheduleURL(from startDate: String, to endDate: String) -> URL? {
        var components = gameScheduleComponents
        components?.queryItems?.append(contentsOf: [URLQueryItem(name: "startDate", value: startDate),
                                                    URLQueryItem(name: "endDate", value: endDate)])
        return components?.url
    }
}
