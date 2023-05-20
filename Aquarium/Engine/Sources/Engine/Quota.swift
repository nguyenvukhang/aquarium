import Foundation

struct Quota {
    var water: Int
    var air: Int

    init(size: Int, waterQuota: Int) {
        water = waterQuota
        air = size - waterQuota
    }

    mutating func increment(_ state: State) {
        switch state {
        case .water: water += 1
        case .air: air += 1
        default: ()
        }
    }

    mutating func decrement(_ state: State) {
        switch state {
        case .water: water -= 1
        case .air: air -= 1
        default: ()
        }
    }
}

extension Quota: Checkable {
    func isValid() -> Bool {
        water >= 0 && air >= 0
    }

    func isSolved() -> Bool {
        water == 0 && air == 0
    }
}

extension [Quota]: Checkable {
    func isValid() -> Bool {
        allSatisfy { q in q.isValid() }
    }

    func isSolved() -> Bool {
        allSatisfy { q in q.isSolved() }
    }
}

extension Quota: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(water),\(air)"
        // let w = State.water.description
        // let a = State.air.description
        // return "\(water)(\(w)), \(air)(\(a))"
    }
}
