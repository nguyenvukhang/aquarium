extension Array: Copyable where Element: Copyable {
    public func copy() -> Array<Element> {
        self.map({ $0.copy() })
    }
}
