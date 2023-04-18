//
//  BoardData.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 19/4/23.
//

import Foundation

struct BoardData: Codable {
    let id: String
    let sums: [String]
    let frame: [String]
    let size: Int
    
    static func create(from url: URL?) -> BoardData {
        guard let unwrappedUrl = url,
              let data = URLSession.synchronousDataTask(with: unwrappedUrl).data,
              let boardData = try? JSONDecoder().decode(BoardData.self, from: data) else {
            assert(false)
        }
        return boardData
    }
}
