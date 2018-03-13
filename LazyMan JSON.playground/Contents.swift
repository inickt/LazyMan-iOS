//: Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import FSCalendar
import PlaygroundSupport
import Pantomime


let date = Date()

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"

let date2 = dateFormatter.date(from: "2018-03-07")

if date == date2
{
    print("equal")
}

var dict: [Date : String] = [:]

dict[date] = "date1"
dict[date2!] = "date2"

print(dict)


let feedURL = URL(string: "http://nhl.freegamez.ga/m3u8/2018-03-12/58556903akc")!

do {
var gameURL = try String(contentsOf: feedURL)
    
    let masterPlaylistURL = URL(string: gameURL)!
    
    print(gameURL)
    
    let m = ManifestBuilder()
    let mp = m.parse(masterPlaylistURL)
    
    print(mp.path)
    
    for index in 0..<mp.getPlaylistCount()
    {
        if let playlist = mp.getPlaylist(index)
        {
            print(playlist.path)
            print(playlist.programId)
            let pp = playlist.path!
            
            print(masterPlaylistURL.URLByReplacingLastPathComponent(pp))
            
            print(playlist.bandwidth)
            print(playlist.resolution)
            print(playlist.framerate)
            
            
        }
    }
}
catch {
    print("error")
}



print()
print()

let nhlStatsURL = "https://statsapi.web.nhl.com/api/v1/schedule?Date=" + dateFormatter.string(from: date) + "&expand=schedule.teams,schedule.linescore,schedule.game.content.media.epg"


if let url = URL(string: nhlStatsURL)
{
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        
        let j = try! JSON(data: data!).dictionaryValue
        
        if let numGames = j["totalItems"]?.int
        {
            if numGames > 0, let dates = j["dates"]?.array
            {
                if dates.count > 0, let games = dates[0].dictionaryValue["games"]?.array
                {
                    for game in games
                    {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        formatter.timeZone = TimeZone(secondsFromGMT: 0)
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        let date3 = formatter.date(from: game["gameDate"].stringValue)
                        
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "MM-dd-yyyy  h:mm a"
                        
                        
                        print(game["teams"]["away"]["team"]["teamName"].stringValue + " at " + game["teams"]["home"]["team"]["teamName"].stringValue)
                        
                        
                        switch game["status"]["abstractGameState"].stringValue
                        {
                        case "Preview":
                            print(dateFormatter2.string(from: date3!))
                            break
                            
                        case "Live":
                            print(game["linescore"]["currentPeriodOrdinal"].stringValue + " – " + game["linescore"]["currentPeriodTimeRemaining"].stringValue)
                            break
                            
                        case "Final":
                            print("Final")
                            break
                            
                        default:
                            print("error")
                            break
                        }
                        
                        
                        
                        if let mediaJSON = game["content"]["media"]["epg"].array, mediaJSON.count > 0
                        {
                            for feedJSON in mediaJSON[0]["items"].arrayValue
                            {
                                print(feedJSON["mediaFeedType"].stringValue + " " + feedJSON["mediaPlaybackId"].stringValue)
                            }
                        }
                        
                        print()
                    }
                }
            }
            else
            {
                print("error")
            }
        }
        else {
            print("error")
        }
    }).resume()
    
    
    
//    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//        print("test1")
//
//        do {
//            let j: JSON = try JSON(data: data!)
//
//            print("test")
//            print(j.dictionaryValue["totalItems"]?.int)
//
//
//        }
//        catch {
//
//        }
//
//
//
//
//
//        if let data = data
//        {
//            do {
//
//
//                if let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
//
//                    if (jsonObj["totalItems"] as! Int) < 1
//                    {
//
//                    }
//
//
//
//                }
//            }
//            catch {
//
//            }
//
//
//        }
//    })
}


PlaygroundPage.current.needsIndefiniteExecution = true
