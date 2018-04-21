//
//  ObjectSelector.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/20/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//


import Foundation

extension String
{
    func replace(_ pattern: String, replacement: String) throws -> String
    {
        let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        
        return regex.stringByReplacingMatches(in: self,
                                              options: [.withTransparentBounds],
                                              range: NSRange(location: 0, length: self.count),
                                              withTemplate: replacement)
    }
}
