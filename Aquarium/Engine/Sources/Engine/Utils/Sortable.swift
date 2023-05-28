public struct Sortable<T> {
    public var value: T
    public var priority: Int
    
    init(_ t: T.Type, value: T, priority: Int = 0) {
        self.value = value
        self.priority = priority
    }
}
