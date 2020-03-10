//
//  League+GameSchedule.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

fileprivate let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    
    if #available(iOS 10.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    } else {
        let iso8601Full: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
        decoder.dateDecodingStrategy = .formatted(iso8601Full)
    }
    return decoder
}()

extension League: GameSchedule {
    func scheduleResponse(for data: Data) throws -> ScheduleResponse {
        switch self {
        case .NHL:
            return try decoder.decode(NHLScheduleResponse.self, from: data)
        case .MLB:
            return try decoder.decode(MLBScheduleResponse.self, from: data)
        }
    }
}
