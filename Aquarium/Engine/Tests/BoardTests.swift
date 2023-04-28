@testable import Engine

import XCTest

//  TEST CASE {
//    "sums": {
//      "cols": [2, 4, 5, 5, 4, 2],
//      "rows": [4, 3, 4, 4, 2, 5]
//    },
//    "matrix":[
//      [1, 2, 2, 2, 2, 3],
//      [1, 1, 2, 4, 2, 3],
//      [1, 2, 2, 4, 4, 3],
//      [1, 2, 2, 2, 2, 3],
//      [1, 5, 5, 5, 6, 3],
//      [1, 1, 1, 5, 6, 3]
//    ]
//  }
//
//  SOLUTION (for reference)
//  [a, w, w, w, w, a]
//  [a, a, w, w, w, a]
//  [a, w, w, w, w, a]
//  [a, w, w, w, w, a]
//  [w, a, a, a, a, w]
//  [w, w, w, w, a, w]

final class BoardTests: XCTestCase {
    private let v = Cell.void, w = Cell.water, a = Cell.air

    /**
     * Asserts that a JSON board is correctly parsed
     * TODO: test for bad json
     */
    func testJsonInitialize() throws {
        let board = try! Board(withJson: """
        { "id": "MDo2LDA3MCw1NzI=", "size": 6,
          "sums": {
            "cols": [2, 4, 5, 5, 4, 2],
            "rows": [4, 3, 4, 4, 2, 5]
          },
          "matrix":[[1, 2, 2, 2, 2, 3],
                    [1, 1, 2, 4, 2, 3],
                    [1, 2, 2, 4, 4, 3],
                    [1, 2, 2, 2, 2, 3],
                    [1, 5, 5, 5, 6, 3],
                    [1, 1, 1, 5, 6, 3]]}
        """)
        XCTAssertEqual(board.size, 6)
        XCTAssertEqual(board.colSums, [2, 4, 5, 5, 4, 2])
        XCTAssertEqual(board.rowSums, [4, 3, 4, 4, 2, 5])
        XCTAssertEqual(board.mat, [
            [v, v, v, v, v, v],
            [v, v, v, v, v, v],
            [v, v, v, v, v, v],
            [v, v, v, v, v, v],
            [v, v, v, v, v, v],
            [v, v, v, v, v, v],
        ])
    }

    func testRowSums() throws {
        var board = Board.empty(size: 6)
        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]

        let size = board.size

        let waterSums = (0 ..< size).map { i in board.rowSum(i, .water) }
        XCTAssertEqual(waterSums, [0, 4, 2, 2, 3, 0])

        let airSums = (0 ..< size).map { i in board.rowSum(i, .air) }
        XCTAssertEqual(airSums, [2, 2, 2, 4, 0, 1])
    }

    func testColumnSums() throws {
        // TODO!
    }

    func testRowStatus() throws {
        var board = Board.empty(size: 6)
        board.colSums = [2, 4, 5, 5, 4, 2]
        board.rowSums = [4, 3, 4, 4, 2, 5]
        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, a, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]

        var (ok, status): (Bool, BoardState)

        (ok, status) = board.validRows()
        XCTAssertEqual(ok, false)
        XCTAssertEqual(status, .rowTooMuchWater(1))

        board.mat[1][4] = .void

        (ok, status) = board.validRows()
        XCTAssertEqual(ok, false)
        XCTAssertEqual(status, .rowTooMuchAir(3))
    }

    func testColumnStatus() throws {
        var board = Board.empty(size: 6)
        board.colSums = [2, 4, 5, 5, 4, 2]
        board.rowSums = [4, 3, 4, 4, 2, 5]
        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]

        var (ok, status): (Bool, BoardState)

        (ok, status) = board.validCols()
        XCTAssertEqual(ok, false)
        XCTAssertEqual(status, .columnTooMuchAir(2))

        board.mat[1][2] = .void
        board.mat[0][2] = .void

        (ok, status) = board.validCols()
        XCTAssertEqual(ok, false)
        XCTAssertEqual(status, .columnTooMuchAir(3))
    }
}

final class SolveStateTests: XCTestCase {
    private let v = Cell.void, w = Cell.water, a = Cell.air

    func testRowSolveState() throws {
        var board = Board.empty(size: 6)
        board.colSums = [2, 4, 5, 5, 4, 2]
        board.rowSums = [4, 3, 4, 4, 2, 5]

        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]
        XCTAssertFalse(board.allRowsSolved)

        board.mat = [[a, w, w, w, w, a],
                     [a, a, w, w, w, a],
                     [a, w, w, w, w, a],
                     [a, w, w, w, w, a],
                     [w, a, a, a, a, w],
                     [w, w, w, w, a, w]]

        XCTAssertTrue(board.allRowsSolved)
    }

    func testAllColumnsSolved() throws {
        var board = Board.empty(size: 6)
        board.colSums = [2, 4, 5, 5, 4, 2]
        board.rowSums = [4, 3, 4, 4, 2, 5]

        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]
        XCTAssertFalse(board.allColsSolved)

        board.mat = [[a, w, w, w, w, a],
                     [a, a, w, w, w, a],
                     [a, w, w, w, w, a],
                     [a, w, w, w, w, a],
                     [w, a, a, a, a, w],
                     [w, w, w, w, a, w]]
        XCTAssertTrue(board.allColsSolved)
    }
}

final class FlowTests: XCTestCase {
    /**
     * One common board for all flow validity tests
     */
    private func board() -> Board {
        let v = Cell.void, w = Cell.water, a = Cell.air
        var board = Board(
            colSums: [2, 4, 5, 5, 4, 2],
            rowSums: [4, 3, 4, 4, 2, 5],
            groups: [[1, 2, 2, 2, 2, 3],
                     [1, 1, 2, 4, 2, 3],
                     [1, 2, 2, 4, 4, 3],
                     [1, 2, 2, 2, 2, 3],
                     [1, 5, 5, 5, 6, 3],
                     [1, 1, 1, 5, 6, 3]]
        )
        board.mat = [[v, v, a, a, v, w],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [w, v, v, v, v, w]]
        return board
    }

    func testAirAboveWater() throws {
        XCTAssertFalse(board().flowValidityAt(row: 1, col: 0))
    }

    func testAirBesideWater() throws {
        XCTAssertFalse(board().flowValidityAt(row: 5, col: 0))
    }

    func testValidFlows() throws {
        let valids = [(0, 5), (5, 5)]
        for (row, col) in valids {
            XCTAssertTrue(board().flowValidityAt(row: row, col: col))
        }
    }
}

final class OverallValidTests: XCTestCase {
    private let v = Cell.void, w = Cell.water, a = Cell.air

    func testOverallValids() throws {
        var board = Board(colSums: [2, 4, 5, 5, 4, 2],
                          rowSums: [4, 3, 4, 4, 2, 5],
                          groups: [[1, 2, 2, 2, 2, 3],
                                   [1, 1, 2, 4, 2, 3],
                                   [1, 2, 2, 4, 4, 3],
                                   [1, 2, 2, 2, 2, 3],
                                   [1, 5, 5, 5, 6, 3],
                                   [1, 1, 1, 5, 6, 3]])

        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]
        XCTAssertFalse(board.isValid)

        board.mat = [[v, v, a, a, v, v],
                     [w, w, a, a, w, w],
                     [v, w, a, a, w, v],
                     [a, a, w, w, a, a],
                     [w, v, w, w, v, v],
                     [v, v, v, v, v, a]]
        XCTAssertFalse(board.isValid)

        board.mat = [[a, w, w, w, w, a],
                     [a, a, w, w, w, a],
                     [a, w, w, w, w, a],
                     [a, w, w, w, w, a],
                     [w, a, a, a, a, w],
                     [w, w, w, w, a, w]]
        XCTAssertTrue(board.isValid)
    }
}
