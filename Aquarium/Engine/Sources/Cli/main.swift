import Engine
import Foundation

let raw_json = """
{
  "id": "MDo2LDA3MCw1NzI=",
  "size": 6,
  "sums": {
    "cols": [2, 4, 5, 5, 4, 2],
    "rows": [4, 3, 4, 4, 2, 5]
  },
  "matrix": [
    [1, 2, 2, 2, 2, 3],
    [1, 1, 2, 4, 2, 3],
    [1, 2, 2, 4, 4, 3],
    [1, 2, 2, 2, 2, 3],
    [1, 5, 5, 5, 6, 3],
    [1, 1, 1, 5, 6, 3]
  ],
}
"""

print("--- start Engine CLI ---")
var board = try Board(withJson: raw_json)
print(board)
board = try Board(withProblemId: "MDo4LDM0MCw5OTA=")
print(board)
print(" --- end Engine CLI ---")
