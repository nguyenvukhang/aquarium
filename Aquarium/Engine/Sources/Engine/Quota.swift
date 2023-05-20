import Foundation

struct Quota {
    var water: Int
    var air: Int
}

extension Quota: Checkable {
    func isValid() -> Bool {
        water >= 0 && air >= 0
    }

    func isSolved() -> Bool {
        water == 0 && air == 0
    }
}
