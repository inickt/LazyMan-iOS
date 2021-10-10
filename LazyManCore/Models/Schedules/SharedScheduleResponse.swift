//
//  SharedScheduleResponse.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/8/20.
//

import Foundation

enum SharedScheduleResponse {
    struct TeamsResponse: Codable {
        let away: TeamGameResponse
        let home: TeamGameResponse
    }

    struct TeamGameResponse: Codable {
        let score: Int?
        let team: TeamResponse
    }
    
    struct TeamResponse: Codable {
        let id: Int
        let name: String
        let abbreviation: String
        let teamName: String
    }

    struct GameStatusResponse: Codable {
        let abstractGameState: String
        let detailedState: String
        let startTimeTBD: Bool?
    }
}

extension SharedScheduleResponse.TeamResponse {
    func asTeam(for league: League) -> Team {
        return Team(name: name,
                    teamName: teamName,
                    abbreviation: abbreviation,
                    league: league)
    }
}
