public struct Game {
    let groups: [[Int]]
    let colSums: [Int]
    let rowSums: [Int]
    var pourPoints: [PourPoint]
    var pourActions: [PourAction]

    var size: Int { groups.count }

    public init(colSums: [Int], rowSums: [Int], groups: [[Int]]) {
        self.colSums = colSums
        self.rowSums = rowSums
        self.groups = groups
        self.pourPoints = Game.getPourPoints(groups: groups)

        var pourActions = [PourAction]()

        for pourPoint in pourPoints {
            pourActions.append(PourAction(.water, flow: pourPoint.waterFlow))
            pourActions.append(PourAction(.air, flow: pourPoint.airFlow))
        }

        // sort by most damaging first
        self.pourActions = pourActions.sorted { $0.flow.count > $1.flow.count }
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

    func backtrack(inst: inout Instance) -> Instance? {
        let delta = inst.fastForward(using: pourPoints)

        if !inst.isValid() {
            inst.undoFastForward(using: delta)
            return nil
        }

        if inst.isSolved() {
            return inst
        }

        let nextActions = pourActions.filter { a in inst.state[a.startPoint].isNone }

        print(inst)

        for pourAction in nextActions {
            let state = pourAction.state
            let delta = inst.pour(state, into: pourAction.flow)
            if let result = backtrack(inst: &inst) {
                return result
            } else {
                inst.undo(state, delta)
            }
        }

        return nil
    }

    public mutating func solve() {
        var inst = Instance(rowSums: rowSums, colSums: colSums, groups: groups)

        // the first big pass
        inst.fastForward(using: pourPoints)
        pourPoints = pourPoints.filter { p in inst.state[p.point].isNone }
        pourActions = pourActions.filter { p in inst.state[p.startPoint].isNone }

        print(inst)
        if let result = backtrack(inst: &inst) {
            inst = result
        }
        print(inst)
    }
}
