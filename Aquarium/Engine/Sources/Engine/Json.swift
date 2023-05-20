import Foundation

/**
 * Enable parsing a JSON string into a Game
 */
extension Game {
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
     * Initialize using a string that is JSON.
     */
    public init(withJson json: String) throws {
        let decoder = JSONDecoder()
        let j = try decoder.decode(JSONBoard.self, from: json.data(using: .utf8)!)
        self.init(colSums: j.sums.cols, rowSums: j.sums.rows, groups: j.matrix)
    }

    /**
     * Initialize by reading a file.
     */
    public init(withJsonFile path: String) throws {
        let cwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let fileUrl = cwd.appendingPathComponent(path)
        let json = try String(contentsOf: fileUrl, encoding: .utf8)
        try self.init(withJson: json)
    }
}
