//
//  String+matches.swift
//  LazyManCore
//
//  Created by Nick Thompson on 4/19/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

extension String {
    func matches(_ pattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)

        let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
        return results.map {
            String(self[Range($0.range, in: self)!])
        }
    }
}
