//
//  LazyManError.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/4/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

protocol LazyManError: Error {
    var messgae: String { get }
}
