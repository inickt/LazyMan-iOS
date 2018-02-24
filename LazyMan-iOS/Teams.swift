//
//  Team.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

enum Leage {
    case NHL
    case MLB
}

protocol Team {
//    static var allTeams: [String : Self] { get }
    
    var location: String { get }
    var shortName: String { get }
    var fullName: String { get }
    var abbreviation: String { get }
    var logo: UIImage { get }
}


final class NHLTeam: Team {
    
    let location: String
    let shortName: String
    let fullName: String
    let abbreviation: String
    let logo: UIImage
    
    static let blackhawks = NHLTeam(location: "Chicago", shortName: "Blackhawks", abbreviation: "CHI", logo: #imageLiteral(resourceName: "blackhawks"))
    
    static var allTeams: [String : NHLTeam] = [:]
    static let league: Leage = Leage.NHL
    
    private init(location: String, shortName: String, abbreviation: String, logo: UIImage) {
        self.location = location
        self.shortName = shortName
        self.fullName = location + " " + shortName
        self.abbreviation = abbreviation
        self.logo = logo
        
        NHLTeam.allTeams[shortName.lowercased()] = self
        
    }
}

final class MLBTeam: Team {
    
    let location: String, shortName: String, fullName: String, abbreviation: String, logo: UIImage
    
    
    static var allTeams: [String : MLBTeam] = [:]
    static let league: Leage = Leage.MLB
    
    private init(location: String, shortName: String, abbreviation: String, logo: UIImage) {
        self.location = location
        self.shortName = shortName
        self.fullName = location + " " + shortName
        self.abbreviation = abbreviation
        self.logo = logo
        
        MLBTeam.allTeams[shortName.lowercased()] = self
        
    }
}

//final class MLBTeam: Team {
//
//}

class Game {
    
    let homeTeam: Team
    let awayTeam: Team
    
    init(homeTeam: NHLTeam, awayTeam: NHLTeam) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    init(homeTeam: MLBTeam, awayTeam: MLBTeam) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
}


















