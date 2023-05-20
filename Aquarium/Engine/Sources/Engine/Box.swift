import Foundation

/**
 * Box class to pass things around by reference
 */
class Box<T> {
    public var val: T
    init(_ val: T) {
        self.val = val
    }
}
