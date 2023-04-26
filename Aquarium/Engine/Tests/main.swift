import Engine

/*
 TEST CASE
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
 
 SOLUTION (for reference)
[[a, w, w, w, w, a],
 [a, a, w, w, w, a],
 [a, w, w, w, w, a],
 [a, w, w, w, w, a],
 [w, a, a, a, a, w],
 [w, w, w, w, a, w]]
 */

describe("Initializing a board") {
    let v = Cell.void, board = try! Board(withJson: """
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
    test("board size") { assertEq(board.size, 6) }
    test("column sums") { assertEq(board.colSums, [2, 4, 5, 5, 4, 2]) }
    test("row sums") { assertEq(board.rowSums, [4, 3, 4, 4, 2, 5]) }
    assertEq(board.mat, [
        [v, v, v, v, v, v],
        [v, v, v, v, v, v],
        [v, v, v, v, v, v],
        [v, v, v, v, v, v],
        [v, v, v, v, v, v],
        [v, v, v, v, v, v],
    ])
}

describe("Board sum operations") {
    var board = Board.empty(size: 6)
    board.colSums = [2, 4, 5, 5, 4, 2]
    board.rowSums = [4, 3, 4, 4, 2, 5]
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("water row sums") {
        let exp = [0, 4, 2, 2, 3, 0]
        for i in 0 ..< board.size {
            r.currentTest = String(format: "water row sums[%d]", i)
            assertEq(board.rowSum(i, .water), exp[i])
        }
    }

    test("air row sums") {
        let exp = [2, 2, 2, 4, 0, 1]
        for i in 0 ..< board.size {
            r.currentTest = String(format: "air row sums[%d]", i)
            assertEq(board.rowSum(i, .air), exp[i])
        }
    }
}

describe("Board row validity checks") {
    var board = Board.empty(size: 6)
    board.colSums = [2, 4, 5, 5, 4, 2]
    board.rowSums = [4, 3, 4, 4, 2, 5]
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("valid rows 1") {
        let (ok, status) = board.validRows()
        assertEq(ok, false)
        assertEq(status, .rowTooMuchWater(1))
    }

    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, v, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, a, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("valid rows 2") {
        let (ok, status) = board.validRows()
        assertEq(ok, false)
        assertEq(status, .rowTooMuchAir(3))
    }
}

describe("Test Board.allRowsSolved") {
    var board = Board.empty(size: 6)
    board.colSums = [2, 4, 5, 5, 4, 2]
    board.rowSums = [4, 3, 4, 4, 2, 5]
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("invalid rows") {
        assertEq(board.allRowsSolved, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[a, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [w, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5
    
    test("valid rows") {
        assertEq(board.allRowsSolved, true)
    }
}

describe("Board col validity checks") {
    var board = Board.empty(size: 6)
    board.colSums = [2, 4, 5, 5, 4, 2]
    board.rowSums = [4, 3, 4, 4, 2, 5]
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("valid cols 1") {
        let (ok, status) = board.validCols()
        assertEq(ok, false)
        assertEq(status, .columnTooMuchAir(2))
    }

    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, v, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, a, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("valid cols 2") {
        let (ok, status) = board.validCols()
        assertEq(ok, false)
        assertEq(status, .columnTooMuchAir(2))
    }
}

describe("Test Board.allColsSolved") {
    var board = Board.empty(size: 6)
    board.colSums = [2, 4, 5, 5, 4, 2]
    board.rowSums = [4, 3, 4, 4, 2, 5]
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("invalid cols") {
        assertEq(board.allColsSolved, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[a, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [w, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5
    
    test("valid cols") {
        assertEq(board.allColsSolved, true)
    }
}

describe("Test Board.flowValidityAt") {
    var board = try! Board(withJson: """
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
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, w], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [w, v, v, v, v, w]] // 5

    test("invalid flow at (1, 0) [cell below should have water]") {
        assertEq(board.flowValidityAt(row: 1, col: 0), false)
    }
    test("invalid flow at (5, 0) [cell on the right should have water]") {
        assertEq(board.flowValidityAt(row: 5, col: 0), false)
    }
    test("valid flow at (0, 5)") {
        assertEq(board.flowValidityAt(row: 0, col: 5), true)
    }
    test("valid flow at (5, 5)") {
        assertEq(board.flowValidityAt(row: 5, col: 5), true)
    }
}

describe("Test Board.allFlowsValid") {
    var board = try! Board(withJson: """
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
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("invalid flows") {
        assertEq(board.allFlowsValid, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[w, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [a, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5

    test("invalid flows") {
        assertEq(board.allFlowsValid, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[a, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [w, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5
    
    test("valid flows") {
        assertEq(board.allFlowsValid, true)
    }
}

describe("Test Board.isValid") {
    var board = try! Board(withJson: """
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
    let w = Cell.water, a = Cell.air, v = Cell.void
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[v, v, a, a, v, v], // 4
                 [w, w, a, a, w, w], // 3
                 [v, w, a, a, w, v], // 4
                 [a, a, w, w, a, a], // 4
                 [w, v, w, w, v, v], // 2
                 [v, v, v, v, v, a]] // 5

    test("invalid board") {
        assertEq(board.isValid, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[w, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [a, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5

    test("invalid board") {
        assertEq(board.isValid, false)
    }
    
    ///////////// 2, 4, 5, 5, 4, 2
    board.mat = [[a, w, w, w, w, a], // 4
                 [a, a, w, w, w, a], // 3
                 [a, w, w, w, w, a], // 4
                 [a, w, w, w, w, a], // 4
                 [w, a, a, a, a, w], // 2
                 [w, w, w, w, a, w]] // 5
    
    test("valid board") {
        assertEq(board.isValid, true)
    }
}

border_tests()

r.end()
