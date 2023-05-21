import Engine

// one-off enums
enum Size: Int { case six = 6; case ten = 10; case fifteen = 15 }
enum Difficulty: String { case easy; case normal; case hard }

/**
 * SET CONFIGS HERE
 */
let size: Size = .fifteen
let difficulty: Difficulty = .hard
let number = 1 // a number from 1 to 6 (inclusive)

/**
 * Using the really clutch config above, this program will look into
 * the ../../problems/problem-db folder for a pre-downloaded problem
 * to solve.
 */
let (s, d) = (size.rawValue, difficulty.rawValue)
let filename = "../../problems/problem-db/\(s)x\(s)_\(d)_v\(number).json"

print("--- START EngineCli ---\n")

var game = try Game(withJsonFile: filename)
game.solve()

print("\n--- END EngineCli ---")
