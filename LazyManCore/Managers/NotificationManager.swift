//
//  NotificationManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 2/17/20.
//

import UIKit

@available(iOS 10.0, *)
public class NotificationManager {

    // MARK: - Static public properties

    public static let shared = NotificationManager()

    // MARK: - Private properties

    private let notificationCenter: UNUserNotificationCenter
    private let gameManager: GameManagerType
    private let teamManager: TeamManagerType

    // MARK: - Init

    public init(gameManager: GameManagerType = GameManager.manager,
                teamManager: TeamManagerType = TeamManager.shared) {
        self.notificationCenter = UNUserNotificationCenter.current()
        self.gameManager = gameManager
        self.teamManager = teamManager
    }

    // MARK: - Public

    public func updateNotifications() {
        let today = Date()
        let end = Calendar.current.date(byAdding: .month, value: 1, to: today)!

        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Notification permissions: \(granted) Error: \(error?.localizedDescription ?? "")")
        }

        League.allCases.forEach { league in
            self.gameManager.getGames(
                from: today,
                to: end,
                league: league,
                ignoreCache: false) { result in
                    switch result {
                    case .success(let games):
                        self.clearNotifications()
                        games.filter { self.teamManager.hasFavoriteTeam(game: $0) }
                            .forEach {
                                print("Adding notification request for game: \($0.awayTeam.teamName) at \($0.homeTeam.teamName): \($0.startTime)")
                                self.notificationCenter.add($0.notificationRequest) { error in
                                    if let error = error {
                                        print("Error adding notification: \(error)")
                                    }
                            }
                        }
                    case .failure(let error):
                        print("Error updating notifications: \(error.messgae)")
                    }
            }
        }
    }

    public func clearNotifications() {
        self.notificationCenter.removeAllPendingNotificationRequests()
    }
}

@available(iOS 10.0, *)
fileprivate extension Game {
    var notificationRequest: UNNotificationRequest {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .second], from: startTime)
        let content = UNMutableNotificationContent()
        content.title = "\(awayTeam.teamName) at \(homeTeam.teamName)"
        content.subtitle = "Game starting soon"
        content.sound = .default

        return UNNotificationRequest(identifier: UUID().uuidString,
                                     content: content,
                                     trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false))
    }
}
