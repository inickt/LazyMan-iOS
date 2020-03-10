//
//  ScheduleLoader.swift
//  LazyManCore
//
//  Created by Nick Thompson on 2/17/20.
//

import Foundation

public protocol ScheduleLoader {
    func load(league: League, date: Date) -> Result<Data, ScheduleLoaderError>
    func load(league: League, from startDate: Date, to endDate: Date) -> Result<Data, ScheduleLoaderError>
}

extension ScheduleLoader {
    public func load(league: League, date: Date) -> Result<Data, ScheduleLoaderError> {
        self.load(league: league, from: date, to: date)
    }
}

public enum ScheduleLoaderError: LazyManError {
    var messgae: String {
        return ""
    }
    
    case urlError(String), loadError(String), unknown
}

public class ScheduleWebLoader: ScheduleLoader {

    // MARK: - Private

    private let session: URLSession

    // MARK: - Init

    public init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        self.session = URLSession(configuration: config)
    }

    // MARK: - ScheduleDataLoader

    public func load(league: League, from startDate: Date, to endDate: Date) -> Result<Data, ScheduleLoaderError> {
        let startDateString = DateUtils.convertToYYYYMMDD(from: startDate)
        let endDateString = DateUtils.convertToYYYYMMDD(from: endDate)

        guard let url = league.gameScheduleURL(from: startDateString, to: endDateString) else {
             return .failure(.urlError("\(startDateString)–\(endDateString) schedule"))
        }

        let (data, _, error) = URLSession.shared.synchronousDataTask(with: url)

        if let data = data {
            return .success(data)
        }
        if let errorMessage = error?.localizedDescription {
            return .failure(.loadError(errorMessage))
        }
        return .failure(.unknown)
    }
}
