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
