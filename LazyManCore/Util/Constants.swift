//
//  Constants.swift
//  LazyManCore
//
//  Created by Nick Thompson on 5/10/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

// Hosts to redirect
public let nhlHosts = ["mf.svc.nhl.com"]
public let mlbHosts = ["mlb-ws-mf.media.mlb.com", "playback.svcs.mlb.com"]
public let allHosts = nhlHosts + mlbHosts

// Server address
public let defaultServerAddress = "freesports.ddns.net"

// Notification for pausing when back to game list on iPhone
public let pauseNotification = NSNotification.Name(rawValue: "pause")

// Framework bundle
internal let frameworkBundle = Bundle(identifier: "dev.nickt.LazyManCore")

// ChromeCast
public let chromecastAppID = "3FDC7292"
