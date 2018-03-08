//: Playground - noun: a place where people can play

import UIKit
import SwiftyJSON
import FSCalendar
import PlaygroundSupport


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
                        print(game["teams"]["away"]["team"]["teamName"].stringValue + " at " + game["teams"]["home"]["team"]["teamName"].stringValue)
                        
                        print(game["linescore"]["currentPeriodOrdinal"].stringValue + " – " + game["linescore"]["currentPeriodTimeRemaining"].stringValue)
                        
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
