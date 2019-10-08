//
//  CDN.swift
//  LazyManCore
//
//  Created by Nick Thompson on 8/17/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

public enum CDN: String, CaseIterable {

    case akamai = "akc", level3 = "l3c"

    public var title: String {
        switch self {
        case .akamai:
            return "Akamai"
        case .level3:
            return "Level 3"
        }
    }
}
