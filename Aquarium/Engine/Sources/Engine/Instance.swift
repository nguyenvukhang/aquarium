public struct Instance {
    var state: [[State]]
    var rowQuota: [Quota]
    var colQuota: [Quota]
    let groups: Box<[[Int]]>

    var size: Int { groups.val.count }

    init(rowQuota: [Quota], colQuota: [Quota], groups: Box<[[Int]]>) {
        self.groups = groups
        self.rowQuota = rowQuota
        self.colQuota = colQuota
        self.state = groups.val.map { r in r.map { _ in State.none }}
    }

    init(rowSums: [Int], colSums: [Int], groups: [[Int]]) {
        let size = groups.count
        let rowQuota = rowSums.map { v in Quota(size: size, waterQuota: v) }
        let colQuota = colSums.map { v in Quota(size: size, waterQuota: v) }
        self.init(rowQuota: rowQuota, colQuota: colQuota, groups: Box(groups))
    }

    /**
     * Copies self, but critically passes groups by reference,
     * and quotas by value
     *
     * Use for backtracking.
     */
    func copy() -> Self {
        Self(rowQuota: rowQuota, colQuota: colQuota, groups: groups)
    }

    /**
     * Tries to pour a certain fluid. If it's valid, the pour is undone,
     * since there is no immediate conclusion.
     *
     * If the result is invalid, we know for sure that the first fluid
     * can't be poured there, so we lock in the second fluid.
     */
    @discardableResult
    mutating func tryPour(_ fluid: State, at pourPoint: PourPoint) -> Bool {
        let delta = pour(fluid, at: pourPoint)

        if isValid() {
            undo(fluid, delta)
            return false
        } else {
            undo(fluid, delta)
            pour(fluid.next, at: pourPoint)
            return true
        }
    }

    /**
     * Makes all forcing moves based on the current state.
     * WARNING: may lead to an invalid state. This happens when pouring
     * both air and water into a particular point leads to an invalid state
     */
    mutating func fastForward(using pourPoints: [PourPoint]) {
        var changed = true
        while changed {
            changed = false
            for pourPoint in pourPoints {
                if tryPour(.water, at: pourPoint) {
                    changed = changed || true
                    continue
                } else {
                    changed = changed || tryPour(.air, at: pourPoint)
                }
                // break off early if invalid state is already reached
                if !isValid() { return }
            }
        }
    }

    /**
     * Returns a list of affected points
     */
    @discardableResult
    mutating func pour(_ state: State, at pourPoint: PourPoint) -> [Point] {
        if !(state == .water || state == .air) { return [] }
        var affected = [Point]()

        for point in pourPoint.getPoints(state) {
            if !self.state[point].isNone {
                continue
            }
            affected.append(point)
            set(state, at: point)
        }

        return affected
    }

    /**
     * Undo the changes created by pour(). Set all the points to .none
     */
    mutating func undo(_ state: State, _ points: [Point]) {
        points.forEach { p in unset(state, at: p) }
    }

    /**
     * Set a point to a particular state, and update the quotas.
     *
     * unchecked precondition: state is one of water/air
     */
    private mutating func set(_ state: State, at point: Point) {
        // do nothing if the state has already been set
        if self.state[point] != .none { return }

        // update the state
        self.state[point] = state

        // update the quotas
        rowQuota[point.row].decrement(state)
        colQuota[point.col].decrement(state)
    }

    /**
     * Unset a point (from water/air back to none)
     */
    private mutating func unset(_ state: State, at point: Point) {
        // do nothing if the target state matches current state
        if self.state[point] == .none { return }

        // update the state
        self.state[point] = .none

        // update the quotas
        rowQuota[point.row].increment(state)
        colQuota[point.col].increment(state)
    }
}

extension Instance: Checkable {
    func isValid() -> Bool {
        rowQuota.isValid() && colQuota.isValid()
    }

    func isSolved() -> Bool {
        rowQuota.isSolved() && colQuota.isSolved()
    }
}
