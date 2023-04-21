import Foundation

class Runner {
    let write_stdout = print
    var hasErr = false
    var currentTest = "", failedTest = ""
    var currentSuite = "", failedSuite = ""
    var printReport = {}

    static let shared = Runner()
    private init() {}
    func fail(_ received: Any, _ expected: Any) {
        if hasErr { return } // only fail once
        failedTest = currentTest
        failedSuite = currentSuite
        hasErr = true
        printReport = { reportDiff(received, expected) }
    }

    func end() { if !r.hasErr { print("All tests passed!".cyan) } }
}

let r = Runner.shared

public enum Color: String {
    case reset = "\u{001B}[0m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case purple = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
}

extension String {
    private func c(_ color: Color) -> String { color.rawValue + self + Color.reset.rawValue }
    var red: String { c(.red) }
    var green: String { c(.green) }
    var blue: String { c(.blue) }
    var yellow: String { c(.yellow) }
    var cyan: String { c(.cyan) }
    var purple: String { c(.purple) }
}

func reportDiff(_ received: Any, _ expected: Any) {
    let line = { (m: String) in let x = String(repeating: "-", count: 15); print(x, m, x) }
    line("received ↓".red)
    print(String(describing: received).red)
    print("==========================================")
    print(String(describing: expected).green)
    line("expected ↑".green)
}

func assertEq<T: Equatable>(_ received: T, _ expected: T) {
    if received != expected { r.fail(received, expected) }
}

enum State: String {
    case start = "[START]"
    case pass = "[PASS]"
    case fail = "[FAIL]"

    func fmt(_ name: String) -> String {
        let x = String(format: "%@ %@", rawValue, name)
        switch self {
        case .start: return x
        case .pass: return x.green
        case .fail: return x.red
        }
    }
}

func banner(_ variant: State, _ name: String) -> String { variant.fmt(name) }

func test(_ name: String, _ tests: () -> Void) {
    if r.hasErr { return }
    print("    * ".green + name)
    r.currentTest = name
    tests()
}

func silentTest(_ name: String, _ tests: () -> Void) {
    if r.hasErr { return }
    r.currentTest = name
    tests()
}

func describe(_ name: String, _ tests: () -> Void) {
    if r.hasErr { return }
    print(banner(.start, name))
    r.currentSuite = name
    tests()
    if !r.hasErr { return print(banner(.pass, name)) }
    print(banner(.fail, name))
    print(String(format: "failed at: [%@]", r.failedTest))
    r.printReport()
}
