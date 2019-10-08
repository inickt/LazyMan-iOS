//
//  Playlist.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public struct Playlist {

    // MARK: - Properties

    public let url: URL
    public let quality: String
    public let bandwidth: Int?
    public let framerate: Int?

    // MARK: - Init

    public init(url: URL, quality: String, bandwidth: Int?, framerate: Int?) {
        self.url = url
        self.quality = quality
        self.bandwidth = bandwidth
        self.framerate = framerate
    }

    // MARK: - Computed Properties

    public var title: String {
        var framerateString = ""
        if let framerate = self.framerate, framerate != 30 {
            framerateString = "\(framerate)"
        }

        let qualityArray = self.quality.split(separator: "x")
        if qualityArray.count == 2 {
            return "\(qualityArray[1])p\(framerateString)"
        } else {
            return "\(self.quality) \(framerateString)"
        }
    }

    public var description: String {
        if let bandwidth = self.bandwidth {
            return "\(bandwidth / 1000) Kbps"
        } else {
            return ""
        }
    }
}

extension Playlist: Equatable {
    public static func == (lhs: Playlist, rhs: Playlist) -> Bool {
        return lhs.url == rhs.url
            && lhs.quality == rhs.quality
            && lhs.bandwidth == rhs.bandwidth
            && lhs.framerate == rhs.framerate
    }
}
