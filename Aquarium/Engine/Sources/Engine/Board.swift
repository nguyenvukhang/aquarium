import Foundation

public enum BoardState: CustomStringConvertible, Equatable {
    case rowTooMuchWater(Int)
    case rowTooMuchAir(Int)
    case columnTooMuchWater(Int)
    case columnTooMuchAir(Int)
    case ok

    public var description: String {
        let fmt = { (s: String, r: String, i: Int) in String(format: "Too much %@ at %@[%d]", s, r, i) }
        switch self {
        case let .columnTooMuchAir(i): return fmt("air", "column", i)
        case let .columnTooMuchWater(i): return fmt("water", "column", i)
        case let .rowTooMuchAir(i): return fmt("air", "row", i)
        case let .rowTooMuchWater(i): return fmt("water", "row", i)
        case _: return "Ok!"
        }
    }
}

public struct Board {
    public var mat: [[Cell]]
    public var colSums: [Int]
    public var rowSums: [Int]
    public var groupMat: [[Int]]
    public var size: Int { rowSums.count }

    /**
     * Response structure from `https://aquarium2.vercel.app/api/get`
     */
    private struct JSONBoard: Codable {
        struct Sums: Codable { let cols: [Int]; let rows: [Int] }
        let id: String
        let size: Int
        let sums: Sums
        let matrix: [[Int]]
    }

    /**
     * Pulls a board from the Aquarium website, and initializes it.
     */
    public init(withProblemId: String) throws {
        let url = URL(string: "https://aquarium2.vercel.app/api/get?id=" + withProblemId)!
        let (raw, _, _) = URLSession.synchronousDataTask(with: url)
        try self.init(withJson: String(data: raw!, encoding: .utf8)!)
    }

    public init(withJson: String) throws {
        let decoder = JSONDecoder()
        let obj = try decoder.decode(JSONBoard.self, from: withJson.data(using: .utf8)!)
        colSums = obj.sums.cols
        rowSums = obj.sums.rows
        groupMat = obj.matrix
        mat = Board.emptyMat(size: obj.size)
    }

    public init(colSums: [Int],
                rowSums: [Int],
                groups: [[Int]])
    {
        mat = Board.emptyMat(size: rowSums.count)
        self.colSums = colSums
        self.rowSums = rowSums
        groupMat = groups
    }

    private init(size: Int) {
        mat = Board.emptyMat(size: size)
        colSums = [Int](repeating: 0, count: size)
        rowSums = [Int](repeating: 0, count: size)
        groupMat = [[Int]](repeating: [Int](repeating: 0, count: size), count: size)
    }

    public static func empty(size: Int) -> Board { Board(size: size) }

    private static func emptyMat(size: Int) -> [[Cell]] {
        [[Cell]](repeating: [Cell](repeating: .void, count: size), count: size)
    }

    private func constructGroupMat(groups: [Int], rowNum: Int, colNum: Int) -> [[Int]] {
        var gMat = [[Int]]()

        for row in 0 ..< rowNum {
            let start = colNum * row, end = start + colNum
            let rowArr = Array(groups[start ..< end])
            gMat.append(rowArr)
        }
        return gMat
    }

    public func rowSum(_ index: Int, _ type: Cell) -> Int {
        mat[index].reduce(0) { acc, cell in acc + (cell == type ? 1 : 0) }
    }

    public func validRows() -> (Bool, BoardState) {
        for i in 0 ..< size {
            if rowSum(i, .water) > rowSums[i] {
                return (false, .rowTooMuchWater(i))
            }
            if rowSum(i, .air) > size - rowSums[i] {
                return (false, .rowTooMuchAir(i))
            }
        }
        return (true, .ok)
    }
}

extension Board: CustomDebugStringConvertible {
    private func borderize(_ i: Int, _ j: Int) -> String {
        let n = size, g = groupMat
        if i == 0 {
            if j == 0 { return "┌" }
            if j == n { return "┐" }
            return g[i][j - 1] == g[i][j] ? "─" : "┬"
        }
        if i == n {
            if j == 0 { return "└" }
            if j == n { return "┘" }
            return g[i - 1][j - 1] == g[i - 1][j] ? "─" : "┴"
        }
        if j == 0 { return g[i - 1][j] == g[i][j] ? "│" : "├" }
        if j == n { return g[i - 1][j - 1] == g[i][j - 1] ? "│" : "┤" }

        // {upper/lower}-{left,right}
        let ul = g[i - 1][j - 1], ur = g[i - 1][j]
        let ll = g[i][j - 1], lr = g[i][j]

        if ul == ur && ur == ll && ll == lr { return " " }
        if ul == ll && ur == lr { return "│" }
        if ul == ur && ll == lr { return "─" }
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

    func joinBorderLine(_ borders: [String]) -> String {
        var result = ""
        let b = borders, L = ["┼", "├", "─", "┌", "┬", "└", "┴"]
        for i in 0 ..< b.count - 1 {
            result += b[i] + (L.contains(b[i]) ? "───" : "   ")
        }
        return result + borders[borders.count - 1]
    }

    func joinCellLine(_ borders: [String], _ cells: [Cell]) -> String {
        var result = "│"
        let b = borders, T = ["┼", "│", "├", "┤", "┌", "┬", "┐"]
        for i in 0 ..< size {
            result += " " + cells[i].description + " "
            result += T.contains(b[i + 1]) ? "│" : " "
        }
        return result
    }

    public var debugDescription: String {
        var stdout = ""
        let print = { x in stdout += x + "\n" }
        let N = (0 ... size)
        let borders = N.map { i in N.map { j in borderize(i, j) } }
        for i in 0 ... size {
            print(joinBorderLine(borders[i]))
            if i == size { break }
            print(joinCellLine(borders[i], mat[i]))
        }
        let _ = stdout.popLast()
        return stdout
    }
}
