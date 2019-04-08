//
//  URLSession+synchernousDataTask.swift
//  LazyMan-iOS
//
//  Created by Nick Thompson on 4/6/19.
//  Copyright © 2019 Nick Thompson. All rights reserved.
//

import Foundation

extension URLSession {

    // swiftlint:disable large_tuple
    func synchronousDataTask(with urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: urlrequest) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }

    func synchronousDataTask(with url: URL) -> (data: Data?, response: URLResponse?, error: Error?) {
        return self.synchronousDataTask(with: URLRequest(url: url))
    }
}
