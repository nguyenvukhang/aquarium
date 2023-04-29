@testable import Engine

import XCTest

final class SolveTests: XCTestCase {
    private let v = Cell.void, w = Cell.water, a = Cell.air

    func testSolves() throws {
        let board = Board(
            colSums: [2, 4, 5, 5, 4, 2],
            rowSums: [4, 3, 4, 4, 2, 5],
            groups: [[1, 2, 2, 2, 2, 3],
                     [1, 1, 2, 4, 2, 3],
                     [1, 2, 2, 4, 4, 3],
                     [1, 2, 2, 2, 2, 3],
                     [1, 5, 5, 5, 6, 3],
                     [1, 1, 1, 5, 6, 3]]
        )

        let expectedSolution = [[a, w, w, w, w, a],
                                [a, a, w, w, w, a],
                                [a, w, w, w, w, a],
                                [a, w, w, w, w, a],
                                [w, a, a, a, a, w],
                                [w, w, w, w, a, w]]

        let solution = board.solve()
        XCTAssertNotNil(solution)
        XCTAssertEqual(solution!.mat, expectedSolution)
    }
}
