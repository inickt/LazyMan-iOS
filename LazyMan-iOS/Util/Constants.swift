//
//  Constants.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 5/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import UIKit

// Hosts to redirect
let nhlHosts = ["mf.svc.nhl.com"]
let mlbHosts = ["mlb-ws-mf.media.mlb.com", "playback.svcs.mlb.com"]
let allHosts = nhlHosts + mlbHosts

// Server address
let serverAddress = "freegamez.ga"

// Notification for pausing when back to game list on iPhone
let pauseNotification = NSNotification.Name(rawValue: "pause")
