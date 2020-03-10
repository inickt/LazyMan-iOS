//
//  League+MLBAMScheduleURL.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/8/20.
//

import Foundation

extension League: MLBAMScheduleURL {
    var gameScheduleComponents: URLComponents? {
        switch self {
        case .NHL:
            return URLComponents(string: "https://statsapi.web.nhl.com/api/v1/schedule?expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg")
        case .MLB:
            return URLComponents(string: "https://statsapi.mlb.com/api/v1/schedule?sportId=1&hydrate=team,linescore,game(content(summary,media(epg)))&language=en")
        }
    }
}
