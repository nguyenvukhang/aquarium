public struct Game {
    enum GameError: Error {
        case unsolved
    }

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

        for pp in pourPoints {
            pourActions.append(PourAction(.water, flow: pp.waterFlow, alt: pp.airFlow))
            pourActions.append(PourAction(.air, flow: pp.airFlow, alt: pp.waterFlow))
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

    func backtrack(_ clone: Instance) -> Instance? {
        var inst = clone

        let delta = inst.fastForward(using: pourPoints)

        if !inst.isValid() {
            inst.undoFastForward(using: delta)
            return nil
        }

        if inst.isSolved() {
            return inst
        }

        let nextActions = pourActions.filter { a in inst.state[a.startPoint].isNone }

        for pourAction in nextActions {
            let state = pourAction.state
            let delta = inst.pour(state, into: pourAction.flow)
            if let result = backtrack(inst) {
                return result
            } else {
                inst.undo(state, delta)
                // Reaching here means the entire subtree of backtracking into
                // pouring the hypothetical fluid fails.
                //
                // Hence we are forced to pour the other fluid
                inst.pour(state.next, into: pourAction.alt)
            }
        }

        return nil
    }

    public func makeInstance() -> Instance {
        Instance(rowSums: rowSums, colSums: colSums, groups: groups)
    }

    public mutating func solve() throws -> Instance {
        var inst = makeInstance()
        let savedQuota = (inst.rowQuota, inst.colQuota)

        // the first big pass
        inst.fastForward(using: pourPoints)
        pourPoints = pourPoints.filter { p in inst.state[p.point].isNone }
        pourActions = pourActions.filter { p in inst.state[p.startPoint].isNone }

        if let result = backtrack(inst) {
            inst = result
        }

        if !inst.isSolved() {
            throw GameError.unsolved
        }

        // restore the quotas for final display
        (inst.rowQuota, inst.colQuota) = savedQuota

        return inst
    }
}
