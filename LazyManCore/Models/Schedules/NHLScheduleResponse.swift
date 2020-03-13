//
//  NHLScheduleResponse.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

struct NHLScheduleResponse: Codable {
    let totalItems: Int
    let totalEvents: Int
    let totalGames: Int
    let totalMatches: Int
    let dates: [DateResponse]

    struct DateResponse: Codable {
        let date: String
        let totalItems: Int
        let totalEvents: Int
        let totalGames: Int
        let totalMatches: Int
        let games: [GameResponse]
    }

    struct GameResponse: Codable {
        let gamePk: Int
        let link: String
        let gameDate: Date
        let status: SharedScheduleResponse.GameStatusResponse
        let teams: SharedScheduleResponse.TeamsResponse
        let linescore: LinescoreResponse
        let content: ContentResponse
    }

    struct ContentResponse: Codable {
        let link: String
        let media: MediaResponse
    }

    struct MediaResponse: Codable {
        let epg: [EpgResponse]
    }

    struct EpgResponse: Codable {
        let title: String
        let items: [EpgItemResponse]
    }

    struct EpgItemResponse: Codable {
        let mediaPlaybackId: String?
        let mediaFeedType: String?
        let mediaPlaybackURL: String?
        let callLetters: String?
        let feedName: String?
        let playbacks: [PlaybackResponse]?
    }

    struct PlaybackResponse: Codable {
        let name: String
        let width: String?
        let height: String?
        let url: String
    }

    struct LinescoreResponse: Codable {
        let currentPeriod: Int
        let currentPeriodOrdinal: String?
        let currentPeriodTimeRemaining: String?
        let powerPlayStrength: String
        let hasShootout: Bool
        let intermissionInfo: IntermissionInfoResponse
    }

    struct IntermissionInfoResponse: Codable {
        let intermissionTimeRemaining: Int
        let intermissionTimeElapsed: Int
        let inIntermission: Bool
    }
}
