import Engine
import Foundation

let raw_json = """
{
  "id": "MDo4LDM0MCw5KTA=",
  "size": 6,
  "sums": {
    "cols": [5, 5, 5, 3, 3, 4],
    "rows": [4, 4, 5, 5, 2, 5]
  },
  "matrix": [
    [1, 1, 2, 2, 2, 2],
    [1, 3, 3, 4, 4, 2],
    [1, 3, 3, 4, 2, 2],
    [5, 4, 4, 4, 6, 2],
    [5, 4, 6, 6, 6, 6],
    [5, 5, 5, 5, 5, 6]
  ],
}
"""
// "play": "https://www.puzzle-aquarium.com/?e=MDo4LDM0MCw5KTA="

print("--- start Engine CLI ---")
var board = try Board(withJson: raw_json)
let n = board.size
(0 ..< n).forEach { i in board.mat[n - 1][i] = .water }
print(board)
// board = try Board(withProblemId: "MDo4LDM0MCw5OTA=")
// print(board)
print(" --- end Engine CLI ---")
