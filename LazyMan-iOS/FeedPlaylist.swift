//
//  FeedPlaylist.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 3/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

class FeedPlaylist: GameOptionCellText
{
    private let url: URL
    private let quality: String
    private let bandwidth: Int?
    private let framerate: Int?
    
    init(url: URL, quality: String, bandwidth: Int?, framerate: Int?)
    {
        self.url = url
        self.quality = quality
        self.bandwidth = bandwidth
        self.framerate = framerate
    }
    
    func getBandwidth() -> Int?
    {
        return self.bandwidth
    }
    
    func getURL() -> URL
    {
        return self.url
    }
    
    func getTitle() -> String
    {
        var framerateString = ""
        
        if let framerate = self.framerate, framerate != 30
        {
            framerateString = "\(framerate)"
        }
        
        let qualityArray = self.quality.split(separator: "x")
        
        guard qualityArray.count == 2 else { return self.quality }
        
        return "\(qualityArray[1])p\(framerateString)"

    }
    
    func getDetail() -> String
    {
        if let bandwidth = self.bandwidth
        {
            return "\(bandwidth / 1000) Kbps"
        }
        else
        {
            return ""
        }
    }
}
