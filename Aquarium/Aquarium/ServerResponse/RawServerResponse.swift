//
//  RawServerResponse.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 19/4/23.
//

import Foundation

struct ColRowSums: Decodable {
    let cols: [Int]
    let rows: [Int]
}

struct RawServerResponse: Decodable {
    let id: String
    let size: Int
    let sums: ColRowSums
    let matrix: [[Int]]
    let play: String
    
    init() {
        self.id = ""
        self.size = 0
        self.sums = ColRowSums(cols: [Int](), rows: [Int]())
        self.matrix = [[Int]]()
        self.play = ""
    }
    
    static func create(from url: URL?) -> RawServerResponse {
        guard let unwrappedUrl = url,
              let data = URLSession.synchronousDataTask(with: unwrappedUrl).data,
              let rawServerResponse = try? JSONDecoder().decode(RawServerResponse.self, from: data) else {
            assert(false)
        }
        return rawServerResponse
    }
}
