//
//  NHLScheduleResponse+ScheduleResponse.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

extension NHLScheduleResponse: ScheduleResponse {
    var games: [String : [Game]] {
        return Dictionary(uniqueKeysWithValues: dates.map { ($0.date, $0.asGames) })
    }
}

private extension NHLScheduleResponse.DateResponse {
    var asGames: [Game] {
        games.map { $0.asGame }
    }
}

private extension NHLScheduleResponse.MediaResponse {
    func asFeeds(for date: Date) -> [Feed] {
        return epg.flatMap { $0.asFeeds(for: date) }
    }
}

private extension NHLScheduleResponse.EpgResponse {
    func asFeeds(for date: Date) -> [Feed] {
        switch title {
        case "NHLTV":
            return items.map {
                Feed(feedType: $0.mediaFeedType ?? "",
                     callLetters: $0.callLetters ?? "",
                     feedName: $0.feedName ?? "",
                     playbackID: Int($0.mediaPlaybackId ?? "") ?? -1,
                     league: .NHL,
                     date: date)
            }
        case "Audio":
            return items.compactMap {
                guard let stringURL = $0.mediaPlaybackURL,
                    let url = URL(string: stringURL) else {
                    return nil
                }
                return Feed(feedType: $0.mediaFeedType ?? "",
                            callLetters: "\($0.callLetters ?? "") - Audio",
                            feedName: $0.feedName ?? "",
                            league: .NHL,
                            url: url)

            }
        case "Extended Highlights", "Recap":
            guard let stringURL = items.first?.mediaPlaybackURL,
                let url = URL(string: stringURL) else {
                return []
            }
            return [Feed(feedType: "",
                         callLetters: "",
                         feedName: title,
                         league: .NHL,
                         url: url)]
        default:
            return []
        }
    }
}

private extension NHLScheduleResponse.GameResponse {
    var asGame: Game {
        let gameState = GameState(abstractState: status.abstractGameState,
                                  detailedState: status.detailedState,
                                  startTimeTBD: status.startTimeTBD ?? false)
        var liveGameState = status.detailedState
        if gameState == .live,
            let currentPeriodOrdinal = linescore.currentPeriodOrdinal,
            let currentPeriodTimeRemaining = linescore.currentPeriodTimeRemaining {
            liveGameState = "\(currentPeriodOrdinal) - \(currentPeriodTimeRemaining)"
        }
        
        var homeTeamScore: Int?
        var awayTeamScore: Int?
        if [.live, .final].contains(gameState) {
            homeTeamScore = teams.home.score
            awayTeamScore = teams.away.score
        }
        
        return Game(homeTeam: teams.home.team.asTeam(for: .NHL),
                    awayTeam: teams.away.team.asTeam(for: .NHL),
                    startTime: gameDate,
                    gameState: gameState,
                    liveGameState: liveGameState,
                    homeTeamScore: homeTeamScore,
                    awayTeamScore: awayTeamScore,
                    feeds: content.media?.asFeeds(for: gameDate) ?? [])
    }
}
