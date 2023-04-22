import Engine

func border_tests() {
    describe("borders: 1x1") {
        let board = Board.empty(size: 1)
        assertEq(board.debugDescription, """
        ┌───┐
        │   │
        └───┘
        """)
    }

    describe("borders: 2x2") {
        var board = Board.empty(size: 2)
        board.groupMat = [[1, 1], [1, 2]]

        assertEq(board.debugDescription, """
        ┌───────┐
        │       │
        │   ┌───┤
        │   │   │
        └───┴───┘
        """)
    }

    describe("borders: 6x6") {
        var board = Board.empty(size: 6)
        board.groupMat = [
            [1, 1, 2, 2, 2, 2],
            [1, 3, 3, 4, 4, 2],
            [1, 3, 3, 4, 2, 2],
            [5, 4, 4, 4, 6, 2],
            [5, 4, 6, 6, 6, 6],
            [5, 5, 5, 5, 5, 6],
        ]

        assertEq(board.debugDescription, """
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
    }

    describe("borders: 6x6, mid-solve") {
        var board = Board.empty(size: 6)
        board.groupMat = [
            [1, 1, 2, 2, 2, 2],
            [1, 3, 3, 4, 4, 2],
            [1, 3, 3, 4, 2, 2],
            [5, 4, 4, 4, 6, 2],
            [5, 4, 6, 6, 6, 6],
            [5, 5, 5, 5, 5, 6],
        ]
        let w = Cell.water, v = Cell.void, a = Cell.air
        board.mat = [
            [v, v, v, v, v, v],
            [w, v, v, v, v, v],
            [w, w, w, v, v, v],
            [a, w, w, w, v, v],
            [a, w, v, v, v, v],
            [a, a, a, a, a, v],
        ]
        assertEq(board.debugDescription, """
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
