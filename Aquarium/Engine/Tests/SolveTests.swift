@testable import Engine

import XCTest

final class SolveTests: XCTestCase {
    func testSolves() throws {
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
        let w = Cell.water, a = Cell.air
        let solver = BacktrackingSolver()

        ///////////// 2, 4, 5, 5, 4, 2
        let expectedSolution = [[a, w, w, w, w, a], // 4
                                [a, a, w, w, w, a], // 3
                                [a, w, w, w, w, a], // 4
                                [a, w, w, w, w, a], // 4
                                [w, a, a, a, a, w], // 2
                                [w, w, w, w, a, w]] // 5

        guard let solverSolution = solver.backtrack(board: board) else {
            // assert fail
            XCTAssertEqual(true, false)
            return
        }
        XCTAssertEqual(solverSolution.mat, expectedSolution)

        var b2 = try! Board(withProblemId: "MDoxNCwxMTYsNzY3")
        guard let solverSolution = solver.backtrack(board: b2) else {
            XCTAssertEqual(true, false)
            return
        }
        b2.mat = solverSolution.mat
        print(b2)
    }
}
