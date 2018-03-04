//
//  Team.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

enum League {
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


final class NHLTeam: Team
{
    // MARK: - Team parameters
    
    let location: String
    let shortName: String
    let fullName: String
    let abbreviation: String
    let logo: UIImage
    
    // MARK: - Teams
    
    static let avalanche = NHLTeam(location: "Colorado", shortName: "Avalanche", abbreviation: "COL", logo: #imageLiteral(resourceName: "avalanche"))
    static let blackhawks = NHLTeam(location: "Chicago", shortName: "Blackhawks", abbreviation: "CHI", logo: #imageLiteral(resourceName: "blackhawks"))
    static let blueJackets = NHLTeam(location: "Columbus", shortName: "Blue Jackets", abbreviation: "CBJ", logo: #imageLiteral(resourceName: "blue-jackets"))
    static let blues = NHLTeam(location: "St. Louis", shortName: "Blues", abbreviation: "STL", logo: #imageLiteral(resourceName: "blues"))
    static let bruins = NHLTeam(location: "Boston", shortName: "Bruins", abbreviation: "BOS", logo: #imageLiteral(resourceName: "bruins"))
    static let canadians = NHLTeam(location: "Montreal", shortName: "Canadiens", abbreviation: "MTL", logo: #imageLiteral(resourceName: "canadiens"))
    static let canucks = NHLTeam(location: "Vancouver", shortName: "Canucks", abbreviation: "VAN", logo: #imageLiteral(resourceName: "canucks"))
    static let capitals = NHLTeam(location: "Washington", shortName: "Capitals", abbreviation: "WSH", logo: #imageLiteral(resourceName: "capitals"))
    static let coyotes = NHLTeam(location: "Arizona", shortName: "Coyotes", abbreviation: "ARI", logo: #imageLiteral(resourceName: "coyotes"))
    static let devils = NHLTeam(location: "New Jersey", shortName: "Devils", abbreviation: "NJD", logo: #imageLiteral(resourceName: "devils"))
    static let ducks = NHLTeam(location: "Anaheim", shortName: "Ducks", abbreviation: "ANA", logo: #imageLiteral(resourceName: "ducks"))
    static let flames = NHLTeam(location: "Calgary", shortName: "Flames", abbreviation: "CGY", logo: #imageLiteral(resourceName: "flames"))
    static let flyers = NHLTeam(location: "Philadelphia", shortName: "Flyers", abbreviation: "PHI", logo: #imageLiteral(resourceName: "flyers"))
    static let goldenKnights = NHLTeam(location: "Vegas", shortName: "Golden Knights", abbreviation: "VGK", logo: #imageLiteral(resourceName: "golden-knights"))
    static let hurricanes = NHLTeam(location: "Carolina", shortName: "Hurricanes", abbreviation: "CAR", logo: #imageLiteral(resourceName: "hurricanes"))
    static let islanders = NHLTeam(location: "New York", shortName: "Islanders", abbreviation: "NYI", logo: #imageLiteral(resourceName: "islanders"))
    static let jets = NHLTeam(location: "Winnipeg", shortName: "Jets", abbreviation: "WPG", logo: #imageLiteral(resourceName: "jets"))
    static let kings = NHLTeam(location: "Los Angeles", shortName: "Kings", abbreviation: "LAK", logo: #imageLiteral(resourceName: "kings"))
    static let lightning = NHLTeam(location: "Tampa Bay", shortName: "Lightning", abbreviation: "TBL", logo: #imageLiteral(resourceName: "lightning"))
    static let mapleLeafs = NHLTeam(location: "Toronto", shortName: "Maple Leafs", abbreviation: "TOR", logo: #imageLiteral(resourceName: "maple-leafs"))
    static let oilers = NHLTeam(location: "Edmonton", shortName: "Oilers", abbreviation: "EDM", logo: #imageLiteral(resourceName: "oilers"))
    static let panthers = NHLTeam(location: "Florida", shortName: "Panthers", abbreviation: "FLA", logo: #imageLiteral(resourceName: "panthers"))
    static let penguins = NHLTeam(location: "Pittsburgh", shortName: "Penguins", abbreviation: "PIT", logo: #imageLiteral(resourceName: "penguins"))
    static let predators = NHLTeam(location: "Nashville", shortName: "Predators", abbreviation: "NSH", logo: #imageLiteral(resourceName: "predators"))
    static let rangers = NHLTeam(location: "New York", shortName: "Rangers", abbreviation: "NYR", logo: #imageLiteral(resourceName: "rangers-NHL"))
    static let redWings = NHLTeam(location: "Detroit", shortName: "Red Wings", abbreviation: "DET", logo: #imageLiteral(resourceName: "red-wings"))
    static let sabres = NHLTeam(location: "Buffalo", shortName: "Sabres", abbreviation: "BUF", logo: #imageLiteral(resourceName: "sabres"))
    static let senators = NHLTeam(location: "Ottawa", shortName: "Senators", abbreviation: "OTT", logo: #imageLiteral(resourceName: "senators"))
    static let sharks = NHLTeam(location: "San Jose", shortName: "Sharks", abbreviation: "SJS", logo: #imageLiteral(resourceName: "sharks"))
    static let stars = NHLTeam(location: "Dallas", shortName: "Stars", abbreviation: "DAL", logo: #imageLiteral(resourceName: "stars"))
    static let wild = NHLTeam(location: "Minnesota", shortName: "Wild", abbreviation: "MIN", logo: #imageLiteral(resourceName: "wild"))
    
    private static var teams: [String : NHLTeam] = [:]
    static var allTeams: [String : NHLTeam]
    {
        return NHLTeam.teams
    }
    
    static let league: League = League.NHL
    
    private init(location: String, shortName: String, abbreviation: String, logo: UIImage) {
        self.location = location
        self.shortName = shortName
        self.fullName = location + " " + shortName
        self.abbreviation = abbreviation
        self.logo = logo
        
        NHLTeam.teams[shortName.lowercased()] = self
    }
}

final class MLBTeam: Team {
    
    let location: String, shortName: String, fullName: String, abbreviation: String, logo: UIImage
    
    
    static var allTeams: [String : MLBTeam] = [:]
    static let league: League = League.MLB
    
    private init(location: String, shortName: String, abbreviation: String, logo: UIImage) {
        self.location = location
        self.shortName = shortName
        self.fullName = location + "1ST 17:32" + shortName
        self.abbreviation = abbreviation
        self.logo = logo
        
        MLBTeam.allTeams[shortName.lowercased()] = self
        
    }
}

//final class MLBTeam: Team {
//
//}

