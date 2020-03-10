//
//  Feed.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public struct Feed: Hashable {

    // MARK: - Properties

    public let feedType: FeedType
    public let callLetters: String
    public let feedName: String
    public let playbackID: Int
    public let league: League
    public let date: Date
    public var title: String {
        if !self.feedName.isEmpty {
            return self.feedName
        } else if !self.callLetters.isEmpty {
            return "\(self.feedType.title) (\(self.callLetters))"
        } else {
            return self.feedType.title
        }
    }

    public let playlistUrl: URL?

    // MARK: - Init

    public init(feedType: String, callLetters: String, feedName: String, playbackID: Int, league: League, date: Date) {
        self.feedType = FeedType(feedType: feedType)
        self.callLetters = callLetters
        self.feedName = feedName
        self.playbackID = playbackID
        self.league = league
        self.date = date
        self.playlistUrl = nil
    }

    // TODO: - This is bad now, refactor
    public init(highlightName: String, league: League, url: URL?) {
        self.playlistUrl = url
        self.feedType = FeedType(feedType: highlightName)
        self.league = league
        self.feedName = highlightName
        self.callLetters = ""
        self.playbackID = 0
        self.date = Date()
    }

    // MARK: - Hashable

    public static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.playbackID == rhs.playbackID && lhs.league == rhs.league && lhs.date == rhs.date
    }
}

public enum FeedType: Equatable, Hashable {
    case home, away, french, national, other(String)

    public var title: String {
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

    public init(feedType: String) {
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
