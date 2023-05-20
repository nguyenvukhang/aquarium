import Foundation

extension String {
    func leftPadding(by len: Int, char c: Character = " ") -> String {
        if count < len {
            return String(repeatElement(c, count: len - count)) + self
        } else {
            return String(suffix(len))
        }
    }
}
