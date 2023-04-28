@testable import Engine

import XCTest

final class BorderTests: XCTestCase {
    private let w = Cell.water, v = Cell.void, a = Cell.air

    func testBorders_1x1() throws {
        let board = Board.empty(size: 1)
        XCTAssertEqual(board.debugDescription, """
        ┌───┐
        │   │
        └───┘
        """)
    }

    func testBorders_2x2() throws {
        var board = Board.empty(size: 2)
        board.groupMat = [[1, 1], [1, 2]]

        XCTAssertEqual(board.debugDescription, """
        ┌───────┐
        │       │
        │   ┌───┤
        │   │   │
        └───┴───┘
        """)
    }

    func testBorders_6x6() throws {
        var board = Board.empty(size: 6)
        board.groupMat = [
            [1, 1, 2, 2, 2, 2],
            [1, 3, 3, 4, 4, 2],
            [1, 3, 3, 4, 2, 2],
            [5, 4, 4, 4, 6, 2],
            [5, 4, 6, 6, 6, 6],
            [5, 5, 5, 5, 5, 6],
        ]

        XCTAssertEqual(board.debugDescription, """
        ┌───────┬───────────────┐
        │       │               │
        │   ┌───┴───┬───────┐   │
        │   │       │       │   │
        │   │       │   ┌───┘   │
        │   │       │   │       │
        ├───┼───────┘   ├───┐   │
        │   │           │   │   │
        │   │   ┌───────┘   └───┤
        │   │   │               │
        │   └───┴───────────┐   │
        │                   │   │
        └───────────────────┴───┘
        """)

        board.mat = [
            [v, v, v, v, v, v],
            [w, v, v, v, v, v],
            [w, w, w, v, v, v],
            [a, w, w, w, v, v],
            [a, w, v, v, v, v],
            [a, a, a, a, a, v],
        ]
        XCTAssertEqual(board.debugDescription, """
        ┌───────┬───────────────┐
        │       │               │
        │   ┌───┴───┬───────┐   │
        │ ■ │       │       │   │
        │   │       │   ┌───┘   │
        │ ■ │ ■   ■ │   │       │
        ├───┼───────┘   ├───┐   │
        │ × │ ■   ■   ■ │   │   │
        │   │   ┌───────┘   └───┤
        │ × │ ■ │               │
        │   └───┴───────────┐   │
        │ ×   ×   ×   ×   × │   │
        └───────────────────┴───┘
        """)
    }
}
