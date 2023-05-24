@testable import Engine

import XCTest

final class IntVariableTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        for intValue in intVariableDomain {
            XCTAssertTrue(intVariable.canAssign(to: intValue))
        }
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(intVariable.canAssign(to: 4))
        XCTAssertFalse(intVariable.canAssign(to: 5))
    }
    
    func testAssignTo_possibleValue_getsAssigned() throws {
        for intValue in intVariableDomain {
            XCTAssertTrue(intVariable.assign(to: intValue))
            let intValue = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(intValue, intValue)
        }
    }
    
    func testAssignTo_impossibleValue_notAssigned() throws {
        XCTAssertFalse(intVariable.assign(to: 4))
        XCTAssertNil(intVariable.assignment)
        intVariable.assign(to: 3)
        XCTAssertFalse(intVariable.assign(to: 5))
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 3)
    }
    
    func testSetDomain_validDomain() {
        let newValidDomain = [10, 9, 8]
        intVariable.setDomain(newDomain: newValidDomain)
        XCTAssertEqual(intVariable.domain, Set(newValidDomain))
    }
    
    // TODO: put back after introducing errors messages
    /*
    func testSetDomain_invalidDomain_throwsError() {
        let invalidDomain = ["a", "b", "c"]
        XCTAssertThrowsError(intVariable.setDomain(newDomain: invalidDomain))
        XCTAssertEqual(intVariable.domain, intVariableDomain)
    }
     */
    
    func testUnassign_assignmentSetToNil() throws {
        intVariable.assign(to: 2)
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
    }
}
