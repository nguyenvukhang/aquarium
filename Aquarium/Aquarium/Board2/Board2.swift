//
//  Board2.swift
//  Aquarium
//
//  Created by Quan Teng Foong on 18/4/23.
//

import Foundation

struct Board2 {
    var mat: [[Bool?]]
    var colSums: [Int]
    var rowSums: [Int]
    var groupMat: [[Int]]
    var numCols: Int {
        colSums.count
    }
    var numRows: Int {
        rowSums.count
    }
    
    init(colSums: [Int],
         rowSums: [Int],
         groups: [Int]) {
        self.mat = [[Bool?]]()
        self.colSums = colSums
        self.rowSums = rowSums
        self.groupMat = [[Int]]()
        self.groupMat = constructGroupMat(groups: groups, rowNum: rowSums.count, colNum: colSums.count)
    }
    
    /*
    init(from boardData: Board2) {
        let sums = boardData.sums.compactMap({ Int($0) })
        let colSums = Array(sums[0..<boardData.size])
        let rowSums = Array(sums[boardData.size...])
        let groups = boardData.frame.compactMap({ Int($0) })
        self.init(colSums: colSums, rowSums: rowSums, groups: groups)
    }
     */
    
    init(from rawServerResponse: RawServerResponse) {
        self.mat = [[Bool?]]()
        self.colSums = rawServerResponse.sums.cols
        self.rowSums = rawServerResponse.sums.rows
        self.groupMat = rawServerResponse.matrix
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

extension Board2: CustomStringConvertible {
    var description2: String {
        var output = ""
        let groupMatAsString = groupMat.map({ $0.map({ String($0) }) })
        for row in groupMatAsString {
            output += row.joined(separator: "") + "\n"
        }
        return output
    }
    
    var description: String {
        let numBorderRows = numRows * 2 + 1
        let numBorderCols = numCols * 2 + 1
        var output = Array(repeating: Array(repeating: "", count: numBorderCols), count: numBorderRows)
        for rowNum in 0..<numBorderRows {
            for colNum in 0..<numBorderCols {
                guard let border = getBorder(rowNum: rowNum, colNum: colNum) else {
                    output[rowNum][colNum] = " "
                    continue
                }
                output[rowNum][colNum] = Constants.getUnicode(for: border) ?? ""
            }
            output[rowNum].append("\n")
        }
        let outputAsString = output.reduce("", { $0 + $1.joined(separator: "") })
        return outputAsString
    }
    
    private func getBorder(rowNum: Int, colNum: Int) -> Border? {
        if rowNum % 2 == 0 {
            if colNum % 2 == 0 {
                return getCrossBorder(rowNum: rowNum, colNum: colNum)
            } else {
                // all hlines
                return getHorizontalBorder(rowNum: rowNum, colNum: colNum)
            }
        } else {
            if colNum % 2 == 0 {
                // all vlines
                return getVerticalBorder(rowNum: rowNum, colNum: colNum)
            } else {
                // empty space
                // return getMatSymbol(rowNum: rowNum, colNum: colNum)
                return nil
            }
        }
    }
    
    private func getHorizontalBorder(rowNum: Int, colNum: Int) -> Border {
        let matRow: Int = rowNum / 2
        let matCol: Int = colNum / 2
        var border = Border()
        
        if matRow < numRows && matRow > 0 {
            if groupMat[matRow][matCol] == groupMat[matRow - 1][matCol] {
                border.left = .t
                border.right = .t
            } else {
                border.left = .T
                border.right = .T
            }
        } else {
            border.left = .T
            border.right = .T
        }
        return border
    }
    
    private func getVerticalBorder(rowNum: Int, colNum: Int) -> Border {
        let matRow: Int = rowNum / 2
        let matCol: Int = colNum / 2
        var border = Border()
        
        if matCol < numCols && matCol > 0 {
            if groupMat[matRow][matCol] == groupMat[matRow][matCol - 1] {
                border.top = .t
                border.bottom = .t
            } else {
                border.top = .T
                border.bottom = .T
            }
        } else {
            border.top = .T
            border.bottom = .T
        }
        return border
    }
    
    private func getCrossBorder(rowNum: Int, colNum: Int) -> Border {
        let matRow: Int = rowNum / 2
        let matCol: Int = colNum / 2
        var border = Border()
        
        // if inside matrix
        if matRow < numRows && matCol < numCols {
            if matRow > 0 {
                // can go up
                if matCol > 0 {
                    // can go left
                    if groupMat[matRow-1][matCol] == groupMat[matRow-1][matCol-1] {
                        border.top = .t
                    } else {
                        border.top = .T
                    }
                    if groupMat[matRow][matCol-1] == groupMat[matRow-1][matCol-1] {
                        border.left = .t
                    } else {
                        border.left = .T
                    }
                    if groupMat[matRow][matCol] == groupMat[matRow-1][matCol] {
                        border.right = .t
                    } else {
                        border.right = .T
                    }
                    if groupMat[matRow][matCol] == groupMat[matRow][matCol-1] {
                        border.bottom = .t
                    } else {
                        border.bottom = .T
                    }
                } else {
                    // cannot go left
                    border.top = .T
                    border.bottom = .T
                    if groupMat[matRow][matCol] == groupMat[matRow-1][matCol] {
                        border.right = .t
                    } else {
                        border.right = .T
                    }
                }
            } else {
                // cannot go up
                if matCol > 0 {
                    // can go left
                    border.left = .T
                    border.right = .T
                    if groupMat[matRow][matCol] == groupMat[matRow][matCol-1] {
                        border.bottom = .t
                    } else {
                        border.bottom = .T
                    }
                } else {
                    // cannot go left
                    border.right = .T
                    border.bottom = .T
                }
            }
        } else {
            // if outside matrix
            if matRow > 0 {
                // can go up
                if matCol > 0 {
                    // can go left
                    if matRow == numRows {
                        // below bottom row
                        if matCol == numCols {
                            // right of right-most col
                            border.top = .T
                            border.left = .T
                        } else {
                            if groupMat[matRow-1][matCol] == groupMat[matRow-1][matCol-1] {
                                border.top = .t
                            } else {
                                border.top = .T
                            }
                            border.left = .T
                            border.right = .T
                        }
                    } else {
                        if matCol == numCols {
                            if groupMat[matRow][matCol-1] == groupMat[matRow-1][matCol-1] {
                                border.left = .t
                            } else {
                                border.left = .T
                            }
                        }
                        border.top = .T
                        border.bottom = .T
                    }
                } else {
                    // cannot go left
                    border.top = .T
                    border.right = .T
                }
            } else {
                // cannot go up
                border.left = .T
                border.bottom = .T
            }
        }
        return border
    }
}
