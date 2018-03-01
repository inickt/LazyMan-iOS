//
//  MainViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/18/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate {

    let games: [Game] = [Game(homeTeam: NHLTeam.blueJackets, awayTeam: NHLTeam.blackhawks)]
    
    @IBOutlet weak var leagueControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var gameTableView: UITableView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar.select(Date(), scrollToDate: false)
        self.calendar.scope = .week
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.gameTableView.indexPathForSelectedRow {
            self.gameTableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GameCell"/*Identifier*/, for: indexPath) as! GameTableViewCell
        cell.updateGameInfo(game: self.games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell at #\(indexPath.row) is selected!")
        
        if let destinationViewController:GameViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "GameView") as? GameViewController {
            
            destinationViewController.game = self.games[indexPath.row]
            
            //Then just push the controller into the view hierarchy
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    @IBAction func test(_ sender: Any) {
        
        if calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        }
        else {
            self.calendar.setScope(.month, animated: true)
        }
    }
}
