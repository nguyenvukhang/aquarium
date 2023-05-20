struct Point {
    let row: Int
    let col: Int

    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

extension Point: CustomDebugStringConvertible {
    var debugDescription: String { "(\(row), \(col))" }
}

extension [[Int]] {
    subscript(p: Point) -> Int {
        get { self[p.row][p.col] } set(v) { self[p.row][p.col] = v }
    }
}

extension [[State]] {
    subscript(p: Point) -> State {
        get { self[p.row][p.col] } set(v) { self[p.row][p.col] = v }
    }
}
