//
//  ScheduleResponse.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

protocol ScheduleResponse {
    var games: [String : [Game]] { get }
}
