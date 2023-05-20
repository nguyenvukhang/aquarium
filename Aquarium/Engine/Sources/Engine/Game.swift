extension [[Int]] {
    subscript(point: Point) -> Int {
        get {
            self[point.row][point.col]
        }
        set(value) {
            self[point.row][point.col] = value
        }
    }
}

public struct Game {
    let groups: [[Int]]
    let colSums: [Int]
    let rowSums: [Int]
    let pourPoints: [PourPoint]

    public init(colSums: [Int], rowSums: [Int], groups: [[Int]]) {
        self.colSums = colSums
        self.rowSums = rowSums
        self.groups = groups
        pourPoints = Game.getPourPoints(groups: groups)
    }

    private static func getPourPoints(groups: [[Int]]) -> [PourPoint] {
        let size = groups.count
        var points = [Point]()
        for r in 0 ..< size {
            for c in 0 ..< size {
                let g = groups[r][c]
                if !points.contains(where: { p in p.row == r && groups[p] == g }) {}
            }
        }
        // let size
        return []
    }
}
