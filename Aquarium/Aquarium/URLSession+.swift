//
//  URLSession.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 18/4/23.
//

import Foundation

extension URLSession {
    static func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.shared.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return (data, response, error)
    }
}
