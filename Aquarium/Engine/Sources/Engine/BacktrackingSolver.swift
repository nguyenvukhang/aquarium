//
//  File.swift
//
//
//  Created by Quan Teng Foong on 26/4/23.
//

import Foundation

public extension Board {
    /// Selects the highest point that is still unassigned,
    /// within the same row, select left-most
    // TODO: try randomize within row? might be faster
    private func order_unassigned_variables() -> [(row: Int, col: Int)] {
        var variables = [(Int, Int)]()
        for rowNum in 0 ..< size {
            for colNum in 0 ..< size {
                if mat[rowNum][colNum] == .void {
                    variables.append((rowNum, colNum))
                }
            }
        }
        return variables
    }

    /// Returns the board in a solved state if solvable,
    /// returns `nil` otherwise.
    func backtrack(board: Board) -> Board? {
        var cloned_board = board
        if cloned_board.isSolved {
            cloned_board.fillAir()
            return cloned_board
        }
        if !cloned_board.isValid {
            return nil
        }
        var variables = cloned_board.order_unassigned_variables()
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

    func backtrack() -> Board? {
        backtrack(board: self)
    }
}
