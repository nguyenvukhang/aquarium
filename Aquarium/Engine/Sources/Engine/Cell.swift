public enum Cell: CustomStringConvertible, CustomDebugStringConvertible, Equatable {
    case void
    case air
    case water

    public var description: String {
        switch self {
        case .void: return " "
        case .air: return "×"
        case .water: return "■"
        }
    }

    public var debugDescription: String { description }
}
