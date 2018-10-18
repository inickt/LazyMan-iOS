//
//  Result.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 9/29/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

class StringError: Error {
    let error: String
    
    init(_ error: String) {
        self.error = error
    }
}
