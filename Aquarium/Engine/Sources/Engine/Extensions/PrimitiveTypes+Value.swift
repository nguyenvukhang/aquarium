extension Int: Value {}

extension Int: Copyable {
    public func copy() -> Int {
        self
    }
}

extension Float: Value {
    init?(_ value: any Value) {
        switch value {
        case is Int:
            self.init(value as! Int)
        case is Float:
            self.init(value as! Float)
        default:
            return nil
        }
    }
}

extension Float: Copyable {
    public func copy() -> Float {
        self
    }
}

extension Bool: Value {}

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        // lhs == false && rhs == true
        !lhs && rhs
    }
}

extension Bool: Copyable {
    public func copy() -> Bool {
        self
    }
}

extension String: Value {}

extension String: Copyable {
    public func copy() -> String {
        self
    }
}
