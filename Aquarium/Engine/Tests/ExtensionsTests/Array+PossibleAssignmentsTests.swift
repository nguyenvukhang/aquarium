@testable import Engine

import XCTest

final class Array_PossibleAssignmentsTests: XCTestCase {
    var testDomains: [[Int]]!
    var expectedPossibleAssignments: Set<[Int]>!
    
    override func setUp() {
        testDomains = [[1, 2],
                       [11, 22],
                       [111, 222]]
        expectedPossibleAssignments = Set([[1, 11, 111],
                                           [1, 11, 222],
                                           [1, 22, 111],
                                           [1, 22, 222],
                                           [2, 11, 111],
                                           [2, 11, 222],
                                           [2, 22, 111],
                                           [2, 22, 222]])
    }
    
    func testPossibleAssignments() {
        let actualPossibleAssignments = Array<Int>.possibleAssignments(domains: testDomains)
        XCTAssertEqual(Set(actualPossibleAssignments), expectedPossibleAssignments)
    }
}
