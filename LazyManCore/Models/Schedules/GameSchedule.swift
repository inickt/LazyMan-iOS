//
//  GameSchedule.swift
//  LazyManCore
//
//  Created by Nick Thompson on 3/7/20.
//

import Foundation

protocol GameSchedule {
    func scheduleResponse(for data: Data) throws -> ScheduleResponse
}
