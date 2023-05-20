import Engine

print("--- START EngineCli ---\n")

let game = try Game(withJsonFile: "../../problems/problem-db/6x6_hard_v3.json")
game.solve()

print("\n--- END EngineCli ---")
