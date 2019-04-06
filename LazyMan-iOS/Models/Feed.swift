//
//  Feed.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

struct Feed: Hashable {

    // MARK: - Properties

    let feedType: FeedType
    let callLetters: String
    let feedName: String
    let playbackID: Int
    let league: League
    let date: Date
    var title: String {
        if self.feedName != "" {
            return self.feedName
        } else if self.callLetters != "" {
            return "\(self.feedType.title) (\(self.callLetters))"
        } else {
            return self.feedType.title
        }
    }

    // MARK: - Init

    init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League, date: Date) {
        self.feedType = FeedType(feedType: feedType)
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
        self.date = date
    }

    // MARK: - Hashable

    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.playbackID == rhs.playbackID && lhs.league == rhs.league && lhs.date == rhs.date
    }
}

enum FeedType: Equatable, Hashable {
    case home, away, french, national, other(String)

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .away:
            return "Away"
        case .french:
            return "French"
        case .national:
            return "National"
        case .other(let name):
            return name
        }
    }

    init(feedType: String) {
        switch feedType {
        case "HOME":
            self = .home
        case "AWAY":
            self = .away
        case "FRENCH":
            self = .french
        case "NATIONAL":
            self = .national
        default:
            self = .other(feedType)
        }
    }
}
