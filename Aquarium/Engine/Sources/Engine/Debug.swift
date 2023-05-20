extension Instance: CustomDebugStringConvertible {
    /** Get the surrounding groups of a border point.
     *  Bounds belong to group 0.
     *  [<upper-left>, <upper-right>, <lower-left>, <lower-right>]
     */
    private func surrounding_groups(_ r: Int, _ c: Int) -> (Int, Int, Int, Int) {
        let (n, g) = (size, groups.val)
        //       ↖︎  ↗︎  ↙︎  ↘︎
        var t = (0, 0, 0, 0)
        if r > 0 {
            if c > 0 { t.0 = g[r - 1][c - 1] } // ↖︎
            if c < n { t.1 = g[r - 1][c] } // ↗︎
        }
        if r < n {
            if c > 0 { t.2 = g[r][c - 1] } // ↙︎
            if c < n { t.3 = g[r][c] } // ↘︎
        }
        return t
    }

    private func border(_ r: Int, _ c: Int) -> Character {
        let n = size
        let (ul, ur, ll, lr) = surrounding_groups(r, c)
        // handle bounds
        if r == 0 {
            if c == 0 { return "┌" }
            if c == n { return "┐" }
            return ll == lr ? "─" : "┬"
        }
        if r == n {
            if c == 0 { return "└" }
            if c == n { return "┘" }
            return ul == ur ? "─" : "┴"
        }
        if c == 0 { return ur == lr ? "│" : "├" }
        if c == n { return ul == ll ? "│" : "┤" }
        // handle the rest
        if ul == ur, ur == ll, ll == lr { return " " }
        if ul == ll, ur == lr { return "│" }
        if ul == ur, ll == lr { return "─" }
        if ul == ur {
            if ul == ll { return "┌" }
            if ur == lr { return "┐" }
            return "┬"
        }
        if ll == lr {
            if ul == ll { return "└" }
            if ur == lr { return "┘" }
            return "┴"
        }
        if ul == ll { return "├" }
        if ur == lr { return "┤" }
        return "┼"
    }

    private func join_state_line(_ borders: [Character], _ state: [State]) -> String {
        var result = "│"
        let JOIN_UP = "┼│├┤┌┬┐"
        for i in 0..<size {
            result.append(" \(state[i].description) ")
            result.append(JOIN_UP.contains(borders[i + 1]) ? "│" : " ")
        }
        return result
    }

    private func join_border_line(_ borders: [Character]) -> String {
        var result = ""
        let JOIN_RIGHT = "┼├─┌┬└┴"
        for i in 0..<size {
            result.append(borders[i])
            result.append(JOIN_RIGHT.contains(borders[i]) ? "───" : "   ")
        }
        if let last = borders.last { result.append(last) }
        return result
    }

    public var debugDescription: String {
        var stdout = ""
        let print = { v in stdout.append(v + "\n") }
        let it = (0...size)
        let borders = it.map { r in it.map { c in border(r, c) }}

        let margin = String(repeatElement(" ", count: 12))

        var colQuotaStr = colQuota.reduce("") { a, c in a + "  " + c.debugDescription }
        colQuotaStr.removeFirst(2)

        print("\(margin) \(colQuotaStr)")

        for i in 0...size {
            print("\(margin) \(join_border_line(borders[i]))")
            if i < size {
                let q = "\(rowQuota[i].debugDescription)".leftPadding(by: 12)
                let s = join_state_line(borders[i], state[i])
                print("\(q) \(s)")
            }
        }
        stdout.removeLast()
        return stdout
    }
}

extension Game: CustomDebugStringConvertible {
    public var debugDescription: String {
        var pp = ""
        for p in pourPoints {
            pp.append("  * \(p)\n")
        }
        pp.removeLast()
        return """
        Game {
        \(pp)
        }
        """
    }
}
