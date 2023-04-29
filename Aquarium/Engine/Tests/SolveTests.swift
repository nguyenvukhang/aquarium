@testable import Engine

import XCTest

final class SolveTests: XCTestCase {
    private let v = Cell.void, w = Cell.water, a = Cell.air

    private func assertEq(_ received: Board?, _ expected: [[Cell]]) {
        XCTAssertNotNil(received)
        var board = received!
        let r = board.debugDescription
        board.mat = expected
        let e = board.debugDescription
        let msg = "\nreceived:\n" + r + "\nexpected:\n" + e + "\n\n"
        XCTAssertEqual(received!.mat, expected, msg)
    }

    func test1() throws {
        // https://www.puzzle-aquarium.com/?e=MDozLDM1MywzNDI=
        let board = Board(
            colSums: [4, 4, 5, 4, 3, 1],
            rowSums: [3, 4, 4, 5, 1, 4],
            groups: [
                [1, 1, 1, 2, 3, 3],
                [1, 1, 1, 2, 3, 3],
                [1, 4, 4, 2, 3, 3],
                [1, 5, 5, 5, 5, 3],
                [6, 6, 6, 6, 5, 3],
                [6, 6, 5, 5, 5, 3],
            ]
        )

        assertEq(board.solve(), [
            [w, w, w, a, a, a],
            [w, w, w, w, a, a],
            [w, w, w, w, a, a],
            [w, w, w, w, w, a],
            [a, a, a, a, w, a],
            [a, a, w, w, w, w],
        ])
    }

    func test2() throws {
        // https://www.puzzle-aquarium.com/?e=MDo4LDg4MCwwNTY=
        let board = Board(
            colSums: [3, 3, 3, 3, 3, 4],
            rowSums: [1, 2, 1, 5, 5, 5],
            groups: [
                [1, 2, 2, 2, 2, 3],
                [1, 2, 2, 2, 2, 3],
                [2, 2, 2, 2, 2, 3],
                [2, 2, 4, 4, 4, 5],
                [6, 2, 4, 4, 5, 5],
                [6, 4, 4, 4, 4, 5],
            ]
        )

        assertEq(board.solve(), [
            [w, a, a, a, a, a],
            [w, a, a, a, a, w],
            [a, a, a, a, a, w],
            [w, w, w, w, w, a],
            [a, w, w, w, w, w],
            [a, w, w, w, w, w],
        ])
    }
}
