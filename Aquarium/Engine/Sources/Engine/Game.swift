public struct Game {
    let groups: [[Int]]
    let colSums: [Int]
    let rowSums: [Int]
    let pourPoints: [PourPoint]

    var size: Int { groups.count }

    public init(colSums: [Int], rowSums: [Int], groups: [[Int]]) {
        self.colSums = colSums
        self.rowSums = rowSums
        self.groups = groups
        self.pourPoints = Game.getPourPoints(groups: groups)
    }

    private static func getPourPoints(groups: [[Int]]) -> [PourPoint] {
        let size = groups.count
        var points = [Point]()
        for r in 0..<size {
            for c in 0..<size {
                let g = groups[r][c]
                if !points.contains(where: { p in p.row == r && groups[p] == g }) {
                    points.append(Point(r, c))
                }
            }
        }
        return points.map { point in PourPoint(point: point, groups: groups) }
    }

    func makeForcingMoves(_ inst: inout Instance) {
        inst.fastForward(using: pourPoints)
    }

    public func solve() {
        var inst = Instance(rowSums: rowSums, colSums: colSums, groups: groups)
        print(inst)
        makeForcingMoves(&inst)
        print(inst)
    }
}
