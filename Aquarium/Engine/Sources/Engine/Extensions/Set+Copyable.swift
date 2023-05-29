extension Set: Copyable where Element: Copyable {
    public func copy() -> Set<Element> {
        Set(self.map({ $0.copy() }))
    }
}
