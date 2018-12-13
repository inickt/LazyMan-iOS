//
//  FeedPlaylist.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

struct FeedPlaylist {
    
    // MARK: - Properties
    
    let url: URL
    let quality: String
    let bandwidth: Int?
    let framerate: Int?
    
    // MARK: - Init
    
    init(url: URL, quality: String, bandwidth: Int?, framerate: Int?) {
        self.url = url
        self.quality = quality
        self.bandwidth = bandwidth
        self.framerate = framerate
    }
    
    // MARK: - Computed Properties
    
    var title: String {
        var framerateString = ""
        if let framerate = self.framerate, framerate != 30 {
            framerateString = "\(framerate)"
        }
        
        let qualityArray = self.quality.split(separator: "x")
        if qualityArray.count == 2  {
            return "\(qualityArray[1])p\(framerateString)"
        }
        else {
            return "\(self.quality) \(framerateString)"
        }
    }
    
    var description: String {
        if let bandwidth = self.bandwidth {
            return "\(bandwidth / 1000) Kbps"
        }
        else {
            return ""
        }
    }
}

extension FeedPlaylist: Equatable {
    static func == (lhs: FeedPlaylist, rhs: FeedPlaylist) -> Bool {
        return lhs.url == rhs.url
            && lhs.quality == rhs.quality
            && lhs.bandwidth == rhs.bandwidth
            && lhs.framerate == rhs.framerate
    }
}
