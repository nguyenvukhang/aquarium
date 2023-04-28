//
//  File.swift
//  
//
//  Created by Quan Teng Foong on 26/4/23.
//

import Foundation

public struct BacktrackingSolver {
    public init() {
        
    }
    
    /// Selects the highest point that is still unassigned,
    /// within the same row, select left-most
    // TODO: try randomize within row? might be faster
    private func order_unassigned_variables(_ board: Board) -> [(row: Int, col: Int)] {
        var variables = [(Int, Int)]()
        for rowNum in 0 ..< board.mat.count {
            for colNum in 0 ..< board.mat[0].count {
                if board.mat[rowNum][colNum] == .void {
                    variables.append((rowNum, colNum))
                }
            }
        }
        return variables
    }

    /// Returns the board in a solved state if solvable,
    /// returns `nil` otherwise.
    public func backtrack(board: Board) -> Board? {
        print(board.debugDescription)
        var cloned_board = board
        if cloned_board.isSolved {
            cloned_board.fillAir()
            return cloned_board
        }
        if !cloned_board.isValid {
            print("FAILED")
            return nil
        }
        var variables = order_unassigned_variables(cloned_board)
        while !variables.isEmpty {
            let (row, col) = variables.removeFirst()
            cloned_board.addWaterAt(row: row, col: col)
            if let result = backtrack(board: cloned_board) {
                return result
            }
            // result == nil, so undo assignment
            cloned_board = board
        }
        return nil
    }
}

