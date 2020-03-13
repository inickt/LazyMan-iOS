//
//  MLBScheduleResponse+ScheduleResponse.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

extension MLBScheduleResponse: ScheduleResponse {
    var games: [String : [Game]] {
        return Dictionary(uniqueKeysWithValues: dates.map { ($0.date, $0.asGames) })
    }
}

private extension MLBScheduleResponse.DateResponse {
    var asGames: [Game] {
        games.map { $0.asGame }
    }
}

private extension MLBScheduleResponse.MediaResponse {
    func asFeeds(for date: Date) -> [Feed] {
        return (epg?.flatMap { $0.asFeeds(for: date) } ?? []) + (epgAlternate?.flatMap { $0.asFeeds(for: date) } ?? [])
    }
}

private extension MLBScheduleResponse.EpgResponse {
    func asFeeds(for date: Date) -> [Feed] {
        switch title {
        case "MLBTV":
            return items.map {
                Feed(feedType: $0.mediaFeedType ?? "",
                     callLetters: $0.callLetters ?? "",
                     feedName: $0.feedName ?? "",
                     playbackID: $0.id,
                     league: .MLB,
                     date: date)
            }
        default:
            return []
        }
    }
}

private extension MLBScheduleResponse.EpgAlternateResponse {
    func asFeeds(for date: Date) -> [Feed] {
        switch title {
        case "Extended Highlights", "Daily Recap":
            guard let playbackUrlString = items.first?.playbacks?.first(where: { $0.name == "HTTP_CLOUD_WIRED_60" })?.url,
                let playbackUrl = URL(string: playbackUrlString) else {
                    return []
            }
            return [Feed(feedType: "",
                         callLetters: "",
                         feedName: title,
                         league: .MLB,
                         url: playbackUrl)]
        default:
            return []
        }
    }
}

private extension MLBScheduleResponse.GameResponse {
    var asGame: Game {
        let gameState = GameState(abstractState: status.abstractGameState,
                                  detailedState: status.detailedState,
                                  startTimeTBD: status.startTimeTBD ?? false)
        var liveGameState = status.detailedState
        if gameState == .live,
            let currentInningOrdinal = linescore?.currentInningOrdinal,
            let inningHalf = linescore?.inningHalf {
            liveGameState = "\(currentInningOrdinal) - \(inningHalf)"
        }

        var homeTeamScore: Int?
        var awayTeamScore: Int?
        if [.live, .final].contains(gameState) {
            homeTeamScore = teams.home.score
            awayTeamScore = teams.away.score
        }
        
        return Game(homeTeam: teams.home.team.asTeam(for: .MLB),
                    awayTeam: teams.away.team.asTeam(for: .MLB),
                    startTime: gameDate,
                    gameState: gameState,
                    liveGameState: liveGameState,
                    homeTeamScore: homeTeamScore,
                    awayTeamScore: awayTeamScore,
                    feeds: content.media?.asFeeds(for: gameDate) ?? [])
    }
}
