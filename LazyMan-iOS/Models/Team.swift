//
//  Team.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

struct Team {
    var location: String
    var shortName: String
    var abbreviation: String
    var logo: UIImage
    var name: String {
        return "\(self.location) \(self.shortName)"
    }
    var league: League
}

extension Team: Comparable {
    static func < (lhs: Team, rhs: Team) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Team, rhs: Team) -> Bool {
        return lhs.name == rhs.name
    }
}
