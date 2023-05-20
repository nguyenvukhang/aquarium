public enum State: CustomStringConvertible, CustomDebugStringConvertible, Equatable {
    case none
    case air
    case water

    var isNone: Bool { self == .none }

    var isFluid: Bool { self == .water || self == .air }

    var next: Self {
        switch self {
        case .none: return .none
        case .water: return .air
        case .air: return .water
        }
    }

    public var description: String {
        switch self {
        case .none: return " "
        case .air: return "×"
        case .water: return "■"
        }
    }

    public var debugDescription: String { description }
}
