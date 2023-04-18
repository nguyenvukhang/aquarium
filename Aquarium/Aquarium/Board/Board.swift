//
//  Board.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 18/4/23.
//

import Foundation

struct Board {
    var mat: [[Bool?]]
    var colSums: [Int]
    var rowSums: [Int]
    var groupMat: [[Int]]
    
    init(colSums: [Int],
         rowSums: [Int],
         groups: [Int]) {
        self.mat = [[Bool?]]()
        self.colSums = colSums
        self.rowSums = rowSums
        self.groupMat = [[Int]]()
        self.groupMat = constructGroupMat(groups: groups, rowNum: rowSums.count, colNum: colSums.count)
    }
    
    init(from boardData: BoardData) {
        let sums = boardData.sums.compactMap({ Int($0) })
        let colSums = Array(sums[0..<boardData.size])
        let rowSums = Array(sums[boardData.size...])
        let groups = boardData.frame.compactMap({ Int($0) })
        self.init(colSums: colSums, rowSums: rowSums, groups: groups)
    }
    
    private func constructGroupMat(groups: [Int], rowNum: Int, colNum: Int) -> [[Int]] {
        var gMat = [[Int]]()
        
        for row in 0..<rowNum {
            let start = colNum * row
            let end = start + colNum
            let rowArr = Array(groups[start..<end])
            gMat.append(rowArr)
        }
        return gMat
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        var output = ""
        let groupMatAsString = groupMat.map({ $0.map({ String($0) }) })
        for row in groupMatAsString {
            output += row.joined(separator: "") + "\n"
        }
        return output
    }
}
