//
//  FeedManager.swift
//  LazyManCore
//
//  Created by Nick Thompson on 8/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation
import Pantomime

public protocol FeedManagerType {
    func getFeedPlaylists(from feed: Feed,
                          using cdn: CDN,
                          ignoreCache: Bool,
                          completion: @escaping (Result<[Playlist], FeedManagerError>) -> Void)
}

public enum FeedManagerError: LazyManError {

    public var messgae: String {
        switch self {
        case .masterURL:
            return "Could not create master playlist URL."
        case .expired:
            return "The stream has expired. Please report the game you are trying to play."
        }
    }

    case masterURL, expired
}

public class FeedManager: FeedManagerType {

    // MARK: - Shared

    public static let shared: FeedManagerType = FeedManager()

    // MARK: - Private Properties

    private var cachedPlaylists = [Feed: [CDN: [Playlist]]]()

    // MARK: - FeedManagerType

    public func getFeedPlaylists(from feed: Feed,
                          using cdn: CDN,
                          ignoreCache: Bool,
                          completion: @escaping (Result<[Playlist], FeedManagerError>) -> Void) {
        if !ignoreCache, let playlists = self.cachedPlaylists[feed]?[cdn] {
            completion(.success(playlists))
        } else {
            self.cachedPlaylists[feed]?[cdn] = nil

            DispatchQueue.global(qos: .userInitiated).async {
                switch self.buildPlaylists(from: feed, using: cdn) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }

                case .success(let playlists):
                    self.cachedPlaylists[feed]?[cdn] = playlists
                    DispatchQueue.main.async {
                        completion(.success(playlists))
                    }
                }
            }
        }
    }

    // MARK: - Private

    private func buildPlaylists(from feed: Feed, using cdn: CDN) -> Result<[Playlist], FeedManagerError> {
        guard let masterURL = feed.playlistUrl ?? self.getMasterURL(league: feed.league,
                                                cdn: cdn,
                                                playbackID: feed.playbackID,
                                                date: feed.date) else {
            return .failure(.masterURL)
        }

        if masterURL.absoluteString.contains("exp"),
            let exp = try? masterURL.absoluteString.replace("(.*)exp=(\\d+)(.*)", replacement: "$2"),
            let expTime = Double(exp),
            Date().timeIntervalSince1970 > expTime + 1000 {
                return .failure(.expired)
        }

        var playlists = [Playlist]()

        // Add master playlist to list, AKA the auto quality.
        playlists.append(Playlist(url: masterURL, quality: "Auto", bandwidth: nil, framerate: nil))

        // Parse the master playlist
        let masterPlaylist = ManifestBuilder().parse(masterURL)

        // Parse other qualities in the playlist
        for index in 0..<masterPlaylist.getPlaylistCount() {
            guard let mediaPlaylist = masterPlaylist.getPlaylist(index),
                let mediaPath = mediaPlaylist.path,
                let mediaURL = masterURL.URLByReplacingLastPathComponent(mediaPath) else {
                    continue
            }

            var framerate: Int?
            if let mpFramerate = mediaPlaylist.framerate?.rounded() {
                framerate = Int(mpFramerate.rounded())
            }

            playlists.append(Playlist(url: mediaURL,
                                          quality: mediaPlaylist.resolution ?? "Unknown",
                                          bandwidth: mediaPlaylist.bandwidth,
                                          framerate: framerate))
        }

        // Sort playlists from highest to lowest quality
        playlists.sort { $0.bandwidth ?? Int.max > $1.bandwidth ?? Int.max }

        return .success(playlists)
    }

    /**
     Gets the master URL for the stream.
     
     - parameter cdn: the CDN the stream should be attempted to be loaded from
     - returns: A URL of this Feed's master playlist, or nil if it cannot be loaded
     */
    private func getMasterURL(league: League, cdn: CDN, playbackID: Int, date: Date) -> URL? {
        let dateString = DateUtils.convertToYYYYMMDD(from: date, timeZone: TimeZone(identifier: "America/Los_Angeles")!)
        let masterURLSource = "http://freegamez.ga/getM3U8.php?league=\(league.rawValue)&date=\(dateString)&id=\(playbackID)&cdn=\(cdn.rawValue)"

        if let contents = try? String(contentsOf: URL(string: masterURLSource)!) {
            return URL(string: contents)
        } else {
            return nil
        }
    }
}
