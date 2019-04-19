//
//  GameListViewController.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 2/18/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit
import FSCalendar

protocol GameListViewControllerType: AnyObject {
    var collapseDetailViewController: Bool { get set }
}

class GameListViewController: UIViewController, GameListViewControllerType {

    // MARK: - IBOutlets

    @IBOutlet private var leagueControl: UISegmentedControl!
    @IBOutlet private var calendar: FSCalendar!
    @IBOutlet private var calendarHeight: NSLayoutConstraint!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var dateButton: UIBarButtonItem!
    private var pageController: UIPageViewController?

    // MARK: - Properties

    internal var collapseDetailViewController = true
    private var weekFormatter = DateFormatter()
    private var date = Date() // Only update with updateDate()
    private var league: League = .NHL {
        didSet {
            guard self.league != oldValue else {
                return
            }

            // swiftlint:disable:next line_length
            let direction: UIPageViewController.NavigationDirection = self.leagueControl.selectedSegmentIndex == 1 ? .forward : .reverse
            self.pageController?.setViewControllers([self.createGameTableView(date: self.date, league: self.league)],
                                                    direction: direction,
                                                    animated: true,
                                                    completion: nil)
        }
    }

    // MARK: - IBActions

    @IBAction private func datePressed(_ sender: UIBarButtonItem) {
        let datePicker = UIAlertController(title: "Select Date", message: "", preferredStyle: .actionSheet)
        let datePickerVC = DatePickerViewController()
        datePicker.setValue(datePickerVC, forKey: "contentViewController")

        let todayAction = UIAlertAction(title: "Today", style: .default) { (_) in
            self.updateDate(date: Date())
        }

        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            self.updateDate(date: datePickerVC.datePicker.date)
        }

        datePicker.addAction(todayAction)
        datePicker.addAction(doneAction)

        self.present(datePicker, animated: true, completion: nil)

        if let popoverController = datePicker.popoverPresentationController {
            popoverController.barButtonItem = sender
            popoverController.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        }

        datePicker.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
        datePickerVC.datePicker.setDate(self.date, animated: false)
    }

    @IBAction private func leagueChanged(_ sender: Any) {
        self.league = self.leagueControl.selectedSegmentIndex == 1 ? .MLB : .NHL
    }

    @IBAction private func settingsButtonPressed(_ sender: Any) {
        guard let settingsViewController = UIStoryboard(name: "Settings", bundle: Bundle.main)
            .instantiateInitialViewController() as? SettingsViewController else {
                return
        }
        let presenter = SettingsPresenter(settingsView: settingsViewController)
        settingsViewController.presenter = presenter
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    // MARK: - Lifecycle

    override func loadView() {
        // swiftlint:disable:previous prohibited_super_call
        // TODO: - Clean this up, remove super call (crashed without it though...)
        super.loadView()
        self.league = SettingsManager.shared.defaultLeague
        self.leagueControl.selectedSegmentIndex = SettingsManager.shared.defaultLeague == .NHL ? 0 : 1
        self.splitViewController?.delegate = self
        self.calendar.scope = .week
        self.weekFormatter.dateFormat = "EEEE  MMMM d, yyyy"
        self.updateDate(date: self.date, wasSwiped: false, firstLoad: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateToday),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - Bad singleton access, need presenter for a lot of this logic
        if SettingsManager.shared.versionUpdates {
            UpdateManager.shared.checkUpdate { result in
                switch result {
                case .available(let newVersion, let isBeta, _, let currentVersion):
                    let versionText = isBeta ? "Beta version" : "version"
                    self.showMessage("\(versionText) \(newVersion) is now avalible. You have \(currentVersion).")
                default:
                    return
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateToday()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: pauseNotification, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pageControllerSegue", let pageController = segue.destination as? UIPageViewController {
            self.pageController = pageController
            self.pageController?.dataSource = self
            self.pageController?.delegate = self
            self.pageController?.setViewControllers([self.createGameTableView(date: self.date, league: self.league)],
                                                    direction: .forward,
                                                    animated: false,
                                                    completion: nil)
        }
    }

    // MARK: - Private

    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)

        let atrributedMessage = NSAttributedString(string: message, attributes: [.foregroundColor: UIColor.white])
        alert.setValue(atrributedMessage, forKey: "attributedMessage")

        self.present(alert, animated: true, completion: nil)

        alert.view.searchVisualEffectsSubview()?.effect = UIBlurEffect(style: .dark)
    }

    private func createGameTableView(date: Date, league: League) -> GameListTableViewController {
        // swiftlint:disable:next all
        let gameListTable = self.storyboard?.instantiateViewController(withIdentifier: "GameTableView") as! GameListTableViewController

        gameListTable.date = date
        gameListTable.league = league
        gameListTable.gameListView = self

        return gameListTable
    }

    private func updateDate(date: Date, wasSwiped: Bool = false, firstLoad: Bool = false) {
        // We only want to perform the following updates if the date changed, or its the first time loading
        if !firstLoad, Calendar.current.isDate(self.date, inSameDayAs: date) {
            return
        }

        // If we are swiping, we don't want to move the pages again
        if !wasSwiped {
            let direction: UIPageViewController.NavigationDirection = date > self.date ? .forward : .reverse
            self.pageController?.setViewControllers([self.createGameTableView(date: date, league: self.league)],
                                                    direction: direction,
                                                    animated: true,
                                                    completion: nil)
        }

        // Update calendar and text
        self.calendar.select(date, scrollToDate: true)
        if self.calendar.scope == .week {
            // swiftlint:disable:next multiline_arguments
            UIView.animate(withDuration: 0.1, animations: {
                self.dateLabel.alpha = 0.2
            }, completion: { (_) in
                self.dateLabel.text = self.weekFormatter.string(from: self.date)
                UIView.animate(withDuration: 0.1) {
                    self.dateLabel.alpha = 1.0
                }
            })
        } else {
            self.dateLabel.text = self.weekFormatter.string(from: date)
        }

        self.date = date
    }

    @objc
    private func updateToday() {
        self.calendar.today = Date()
    }
}

extension GameListViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.updateDate(date: date)
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()

        if calendar.scope == .week {
            calendar.appearance.headerTitleColor = UIColor.clear
            UIView.animate(withDuration: 0.1) {
                self.dateLabel.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.001, animations: {
                self.dateLabel.alpha = 0.0
            }, completion: { (_) in
                calendar.appearance.headerTitleColor = UIColor.white
            })
        }
    }
}

extension GameListViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let before = viewController as? GameListTableViewController,
            let date = Calendar.current.date(byAdding: .day, value: -1, to: before.date) {
            return self.createGameTableView(date: date, league: self.league)
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let after = viewController as? GameListTableViewController,
            let date = Calendar.current.date(byAdding: .day, value: 1, to: after.date) {
            return self.createGameTableView(date: date, league: self.league)
        }

        return nil
    }
}

extension GameListViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed, let date = (pageViewController.viewControllers?.last as? GameListTableViewController)?.date {
            self.updateDate(date: date, wasSwiped: true, firstLoad: false)
        }
    }
}

extension GameListViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return self.collapseDetailViewController
    }
}
