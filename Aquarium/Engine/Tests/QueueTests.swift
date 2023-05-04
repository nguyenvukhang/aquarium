@testable import Engine

import XCTest

final class QueueTests: XCTestCase {
    func testAqInAqOut() throws {
        let q = Queue<Int>()
        q.enqueue(1)
        q.enqueue(2)
        q.enqueue(3)
        XCTAssertEqual(q.dequeue(), 1)
        XCTAssertEqual(q.dequeue(), 2)
        XCTAssertEqual(q.dequeue(), 3)
        XCTAssertTrue(q.isEmpty)
    }

    func testMix() throws {
        let q = Queue<Int>()
        q.enqueue(1)
        q.enqueue(2)
        XCTAssertEqual(q.dequeue(), 1)
        q.enqueue(3)
        XCTAssertEqual(q.dequeue(), 2)
        XCTAssertEqual(q.dequeue(), 3)
    }

    func testEmpty() throws {
        let q = Queue<Int>()
        XCTAssertTrue(q.isEmpty)
        XCTAssertEqual(q.dequeue(), nil)
    }

    func testFiqedThenEmpty() throws {
        let q = Queue<Int>()
        q.enqueue(1)
        q.dequeue()
        XCTAssertTrue(q.isEmpty)
        XCTAssertEqual(q.dequeue(), nil)
    }
}
