//
//  CDN.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 8/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

enum CDN: String, CaseIterable {

    case akamai = "akc", level3 = "l3c"

    var title: String {
        switch self {
        case .akamai:
            return "Akamai"
        case .level3:
            return "Level 3"
        }
    }
}
