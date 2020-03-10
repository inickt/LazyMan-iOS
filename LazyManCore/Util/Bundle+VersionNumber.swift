//
//  Bundle+VersionNumber.swift
//  LazyMan-Core
//
//  Created by Nick Thompson on 12/20/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

extension Bundle {
    public var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    public var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
