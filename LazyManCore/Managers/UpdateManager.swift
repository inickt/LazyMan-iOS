//
//  UpdateManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 5/12/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public protocol UpdateManagerType {
    /// Check for a current version update.
    func checkUpdate(completion: @escaping (UpdateResult) -> Void)
}

public enum UpdateResult {
    case available(newVersion: String, isBeta: Bool, url: URL, currentVersion: String)
    case upToDate
    case error(message: String)
}

public class UpdateManager: UpdateManagerType {

    // MARK: - Private Release Struct

    private struct Release: Codable {
        let url: URL
        let tagName: String
        let prerelease: Bool
        let body: String

        private enum CodingKeys: String, CodingKey {
            case url = "html_url"
            case tagName = "tag_name"
            case prerelease, body
        }

        var version: String? {
            return try? self.tagName.matches(#"(:?\d+\.\d+\.\d+)"#).first
        }
    }

    // MARK: - Shared

    public static let shared: UpdateManagerType = UpdateManager()

    // MARK: - Private properties

    private let githubReleaseURL = URL(string: "https://api.github.com/repos/inickt/LazyMan-iOS/releases")!
    private let settingsManager: SettingsManagerType

    // MARK: - Initialization

    public init(settingsManager: SettingsManagerType = SettingsManager.shared) {
        self.settingsManager = settingsManager
    }

    // MARK: - UpdateManagerType

    public func checkUpdate(completion: @escaping (UpdateResult) -> Void) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)

        session.dataTask(with: githubReleaseURL) { (data, _, error) in
            guard let data = data, let releases = try? JSONDecoder().decode([Release].self, from: data) else {
                DispatchQueue.main.async {
                    completion(.error(message: error?.localizedDescription ?? "Unable to load update information."))
                }
                return
            }
            let current = Bundle.main.releaseVersionNumber

            for release in releases {
                if release.prerelease && !self.settingsManager.betaUpdates {
                    continue
                }
                guard let version = release.version else {
                    continue
                }
                if current.compare(version, options: .numeric) == .orderedAscending {
                    DispatchQueue.main.async {
                        completion(.available(newVersion: version,
                                              isBeta: release.prerelease,
                                              url: release.url,
                                              currentVersion: current))
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                completion(.upToDate)
            }
        }.resume()
    }
}
