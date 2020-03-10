//
//  Team.swift
//  LazyManCore
//
//  Created by Nick Thompson on 2/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public struct Team: Codable {

    public var name: String
    public var teamName: String
    public var abbreviation: String
    public var league: League
    public var logo: Image? {
        // TODO broken on macOS
        return try? Image(named: "\(self.league)/\(self.teamName.lowercased().replace(" ", replacement: "-"))", in: frameworkBundle, compatibleWith: nil)
    }

    public init(name: String, teamName: String, abbreviation: String, league: League) {
        self.name = name
        self.teamName = teamName
        self.abbreviation = abbreviation
        self.league = league
    }
}

extension Team: Comparable {
    public static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.name < rhs.name
    }

    public static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }
}
