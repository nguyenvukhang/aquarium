extension Int: Value {}

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

extension Bool: Value {}

extension String: Value {}
