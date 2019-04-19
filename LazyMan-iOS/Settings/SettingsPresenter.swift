//
//  SettingsPresenter.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/7/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation
import OptionSelector

protocol SettingsPresenterType: AnyObject {
    var favoriteNHLTeamSelector: MultiOptionSelector<Team> { get }
    var favoriteMLBTeamSelector: MultiOptionSelector<Team> { get }

    func showDefaults()
    func setDefault(league: League)
    func setDefault(quality: Quality)
    func setDefault(cdn: CDN)
    func setPreferFrench(enabled: Bool)
    func setVersionUpdates(enabled: Bool)
    func setBetaUpdates(enabled: Bool)
    func updatePressed()
    func githubPressed()
    func rLazyManPressed()
}

class SettingsPresenter: SettingsPresenterType {

    // MARK: - Properties

    private weak var settingsView: SettingsViewType?
    private var settingsManager: SettingsManagerType
    private var teamManager: TeamManagerType

    // MARK: - Initialization

    init(settingsView: SettingsViewType,
         settingsManager: SettingsManagerType = SettingsManager.shared,
         teamManager: TeamManagerType = TeamManager.shared,
         updateManager: UpdateManager = UpdateManager.shared) {
        self.settingsView = settingsView
        self.settingsManager = settingsManager
        self.teamManager = teamManager
    }

    // MARK: - SettingsPresenterType

    internal private (set) lazy var favoriteNHLTeamSelector: MultiOptionSelector<Team> = {
        let teams = self.teamManager.nhlTeams.values.sorted()
        let selector = MultiOptionSelector<Team>(teams, selected: self.settingsManager.favoriteNHLTeams) { teams in
            self.settingsManager.favoriteNHLTeams = teams
            self.settingsView?.showNHLTeams(text: self.formatTeams(teams: teams))
        }
        return selector
    }()
    internal private (set) lazy var favoriteMLBTeamSelector: MultiOptionSelector<Team> = {
        let teams = self.teamManager.mlbTeams.values.sorted()
        let selector = MultiOptionSelector<Team>(teams, selected: self.settingsManager.favoriteMLBTeams) { teams in
            self.settingsManager.favoriteMLBTeams = teams
            self.settingsView?.showMLBTeams(text: self.formatTeams(teams: teams))
        }
        return selector
    }()

    func showDefaults() {
        self.settingsView?.showNHLTeams(text: self.formatTeams(teams: self.settingsManager.favoriteNHLTeams))
        self.settingsView?.showMLBTeams(text: self.formatTeams(teams: self.settingsManager.favoriteMLBTeams))
        self.settingsView?.showDefault(league: self.settingsManager.defaultLeague)
        self.settingsView?.showDefault(quality: self.settingsManager.defaultQuality)
        self.settingsView?.showDefault(cdn: self.settingsManager.defaultCDN)
        self.settingsView?.showPreferFrench(isOn: self.settingsManager.preferFrench)
        self.settingsView?.showVersionUpdates(isOn: self.settingsManager.versionUpdates)
        self.settingsView?.showBetaUpdates(isOn: self.settingsManager.betaUpdates,
                                           enabled: self.settingsManager.versionUpdates)
    }

    func setDefault(league: League) {
        self.settingsManager.defaultLeague = league
    }

    func setDefault(quality: Quality) {
        self.settingsManager.defaultQuality = quality
    }

    func setDefault(cdn: CDN) {
        self.settingsManager.defaultCDN = cdn
    }

    func setPreferFrench(enabled: Bool) {
        self.settingsManager.preferFrench = enabled
    }

    func setVersionUpdates(enabled: Bool) {
        self.settingsManager.versionUpdates = enabled
        self.settingsManager.betaUpdates = false
        self.settingsView?.showBetaUpdates(isOn: self.settingsManager.betaUpdates, enabled: enabled)
    }

    func setBetaUpdates(enabled: Bool) {
        self.settingsManager.betaUpdates = enabled
    }

    func updatePressed() {
        // TODO: UpdateManager.checkUpdate(completion: self.showMessage, userPressed: true)
    }

    func githubPressed() {
        self.settingsView?.open(url: URL(string: "https://github.com/inickt/LazyMan-iOS/")!)
    }

    func rLazyManPressed() {
        self.settingsView?.open(url: URL(string: "https://www.reddit.com/r/LazyMan/")!)
    }

    // MARK: - Private

    private func formatTeams(teams: [Team]) -> String {
        let teamText = teams.sorted().reduce("") {
            "\($0.isEmpty ? "" : "\($0), ")\($1.shortName)"
        }
        return teamText.isEmpty ? "None" : teamText
    }
}
