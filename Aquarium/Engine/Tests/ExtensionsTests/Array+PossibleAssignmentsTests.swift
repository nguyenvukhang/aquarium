@testable import Engine

import XCTest

final class Array_PossibleAssignmentsTests: XCTestCase {
    var testDomains: [[Int]]!
    var expectedPermutations: Set<[Int]>!
    
    override func setUp() {
        testDomains = [[1, 2],
                       [11, 22],
                       [111, 222]]
        expectedPermutations = Set([[1, 11, 111],
                                    [1, 11, 222],
                                    [1, 22, 111],
                                    [1, 22, 222],
                                    [2, 11, 111],
                                    [2, 11, 222],
                                    [2, 22, 111],
                                    [2, 22, 222]])
    }
    
    func testPermutations() {
        let actualPermutations = Array<Int>.possibleAssignments(domains: testDomains)
        print(actualPermutations)
        XCTAssertEqual(Set(actualPermutations), expectedPermutations)
    }
}
