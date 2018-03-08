//
//  MainViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/18/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import FSCalendar

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GameDataDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    

    var games: [Game] = []
    
    @IBOutlet weak var leagueControl: UISegmentedControl!

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayButton: UIBarButtonItem!
    
    @IBAction func todayPressed(_ sender: Any) {
        self.selectedDate = Date()
        self.calendar.select(self.selectedDate, scrollToDate: true)
    }
    
    private var selectedDate: Date = Date()
    {
        didSet {
            if oldValue != selectedDate
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE  MMMM d, yyyy"
                
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "yyyy-MM-dd"
                
                GameManager.manager.reloadGames(date: formatter2.string(from: self.selectedDate))
                
                if self.calendar.scope == .week {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.dateLabel.alpha = 0.2
                    }) { (finished) in
                        self.dateLabel.text = formatter.string(from: self.selectedDate)
                        UIView.animate(withDuration: 0.1, animations: {
                            self.dateLabel.alpha = 1.0
                        })
                    }
                }
                else {
                    self.dateLabel.text = formatter.string(from: self.selectedDate)
                }
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        self.selectedDate = Date()
        self.calendar.select(Date(), scrollToDate: false)
        self.calendar.scope = .week
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameManager.manager.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale.current
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
    
    func updateGames(nhlGames: [Game]?, mlbGames: [Game]?)
    {
        if let goodGames = nhlGames
        {
            self.games = goodGames
            self.gameTableView.reloadData()
        }
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
        
        if calendar.scope == .week {
            calendar.appearance.headerTitleColor = UIColor.clear
            UIView.animate(withDuration: 0.1, animations: {
                self.dateLabel.alpha = 1.0
            })
        }
        else {
            UIView.animate(withDuration: 0.001, animations: {
                self.dateLabel.alpha = 0.0
            }, completion: { (_) in
                calendar.appearance.headerTitleColor = UIColor.white
            })
        }
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.selectedDate = date
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
    
    @IBAction func refreshPressed(_ sender: Any) {
//        if let goodGames = manager.getGames(date: self.selectedDate).nhlGames
//        {
//            self.games = goodGames
//        }
//        self.gameTableView.reloadData()
    }
}




