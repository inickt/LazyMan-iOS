//
//  GameListViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/18/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import FSCalendar

protocol GameListViewControllerType: class
{
    func updateDate(date: Date)
    func updateCalendar(date: Date)
    func updateRefreshing(refreshing: Bool)
    func updateError(error: String?)
    func showError(message: String)
    func updateGames()
    func showDatePicker(currentDate: Date, sender: UIBarButtonItem)
}

class GameListViewController: UIViewController, GameListViewControllerType
{
    // MARK: - IBOutlets
    
    @IBOutlet private weak var leagueControl: UISegmentedControl!
    @IBOutlet private weak var calendar: FSCalendar!
    @IBOutlet private weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dateButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func datePressed(_ sender: UIBarButtonItem)
    {
        self.presenter.datePressed(sender: sender)
    }
    
    @IBAction func refreshPressed(_ sender: Any)
    {
        self.tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.height), animated: true)
        self.refreshControl.beginRefreshing()
        self.presenter.refreshPressed()
    }
    
    @IBAction func leagueChanged(_ sender: Any)
    {
        self.presenter.leagueChanged(league: self.leagueControl.selectedSegmentIndex == 1 ? .MLB : .NHL)
    }
    
    // MARK: - Properties
    
    private var presenter: GameListPresenterType!
    private var weekFormatter = DateFormatter()
    private var refreshControl = UIRefreshControl()
    private var collapseDetailViewController = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter = GameListPresenter(view: self)
        self.presenter.viewDidLoad()
        
        self.calendar.scope = .week
        self.weekFormatter.dateFormat = "EEEE  MMMM d, yyyy"
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.backgroundView = self.refreshControl
        }
        self.refreshControl.addTarget(self, action: #selector(refreshGames), for: .valueChanged)
        self.refreshControl.tintColor = .lightGray
        
        self.splitViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.presenter.viewWillAppear()
        
        self.calendar.today = Date()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.presenter.viewDidAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showGameView",
            let navController = segue.destination as? UINavigationController,
            let gameViewController = navController.topViewController as? GameViewController,
            let index = sender as? Int, index < self.presenter.getGameCount()
        {
            self.collapseDetailViewController = false
            
            gameViewController.presenter = GamePresenter(game: self.presenter.getGames()[index])
            gameViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            gameViewController.navigationItem.leftItemsSupplementBackButton = true
        }
    }
        
    // MARK: - GameListViewControllerType
    
    func updateDate(date: Date)
    {
        if self.calendar.scope == .week
        {
            UIView.animate(withDuration: 0.1, animations: {
                self.dateLabel.alpha = 0.2
            }) { (_) in
                self.dateLabel.text = self.weekFormatter.string(from: date)
                UIView.animate(withDuration: 0.1, animations: {
                    self.dateLabel.alpha = 1.0
                })
            }
        }
        else {
            self.dateLabel.text = self.weekFormatter.string(from: date)
        }
    }
    
    func updateCalendar(date: Date)
    {
        self.calendar.select(date, scrollToDate: true)
    }
    
    func updateRefreshing(refreshing: Bool)
    {
        if refreshing
        {
            self.tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.height), animated: true)
            self.refreshControl.beginRefreshing()
        }
        else
        {
            self.refreshControl.endRefreshing()
        }
    }
    
    func updateError(error: String?)
    {
        guard let error = error else
        {
            self.errorLabel.isHidden = true
            return
        }
        
        self.errorLabel.isHidden = false
        self.errorLabel.text = error
    }
    
    func showError(message: String)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor : UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")
        
        self.present(alert, animated: true, completion: nil)
        
        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }
    
    func updateGames()
    {
        self.tableView.reloadData()
    }
    
    func showDatePicker(currentDate: Date, sender: UIBarButtonItem)
    {
        let datePicker = UIAlertController(title: "Select Date", message: "", preferredStyle: .actionSheet)
        let datePickerVC = DatePickerViewController()
        datePicker.setValue(datePickerVC, forKey: "contentViewController")
        
        let todayAction = UIAlertAction(title: "Today", style: .default) { (_) in
            let today = Date()
            self.presenter.dateSelected(date: today)
            self.calendar.select(today)
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            self.presenter.dateSelected(date: datePickerVC.datePicker.date)
            self.calendar.select(datePickerVC.datePicker.date)
        }
        
        datePicker.addAction(todayAction)
        datePicker.addAction(doneAction)
        
        self.present(datePicker, animated: true, completion: nil)
        
        if let popoverController = datePicker.popoverPresentationController
        {
            popoverController.barButtonItem = sender
            popoverController.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        }
        
        datePicker.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
        datePickerVC.datePicker.setDate(currentDate, animated: false)
    }
    
    // MARK: - Private
    
    @objc
    private func refreshGames()
    {
        self.presenter.refreshPressed()
    }
}

extension GameListViewController: FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        self.presenter.dateSelected(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool)
    {
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
}

extension GameListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showGameView", sender: indexPath.row)
    }
}

extension GameListViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.presenter.getGameCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameTableViewCell else { return UITableViewCell() }
        
        cell.updateGameInfo(game: self.presenter.getGames()[indexPath.row])
        return cell
    }
}

extension GameListViewController: UISplitViewControllerDelegate
{
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool
    {
        return collapseDetailViewController
    }
}
