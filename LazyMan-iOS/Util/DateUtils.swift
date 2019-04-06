//
//  DateUtils.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 10/25/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

enum DateUtils {

    // MARK: - Private Properties

    static private let gmtFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static private let yyyymmddFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // MARK: - Public Helpers

    // TODO: Make sure correct for timezones/day boundries/etc!!!
    static func convertToYYYYMMDD(from date: Date) -> String {
        return self.yyyymmddFormatter.string(from: date)
    }

    static func convertGMTtoDate(from date: String) -> Date? {
        return self.gmtFormatter.date(from: date)
    }
}
