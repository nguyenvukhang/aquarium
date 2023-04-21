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

    public func valid() -> Bool {
        // let pieces = Int32(0)
        for i in 0 ..< size {
            for j in 0 ..< size {
                print(i, j)
            }
        }
        // hi
        return true
    }
}

extension Board: CustomDebugStringConvertible {
    private func spaceSeparated(_ a: [Any]) -> String {
        a.description.dropFirst().dropLast().replacingOccurrences(of: ",", with: "")
    }

    /**
     * TODO? add cell borders
     */
    public var debugDescription: String {
        var stdout = "Board {\n"
        let line = { (line: String) in stdout += line + "\n" }
        line("    " + spaceSeparated(colSums))
        for i in 0 ..< mat.count {
            line("  " + rowSums[i].description + " " + spaceSeparated(mat[i]))
        }
        return stdout + "}"
    }
}
