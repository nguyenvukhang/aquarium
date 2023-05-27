extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        return self == other
    }
    
    private func isExactlyEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}

extension [Equatable] {
    func isEqual(_ other: [any Equatable]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }
}

extension [[Equatable]] {
    func isEqual(_ other: [[any Equatable]]) -> Bool {
        var equal = self.count == other.count
        for idx in 0 ..< self.count {
            equal = equal && self[idx].count == other[idx].count
            equal = equal && self[idx].isEqual(other[idx])
        }
        return equal
    }
}
