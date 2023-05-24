@testable import Engine

import XCTest

final class StringVariableTests: XCTestCase {
    var stringVariableDomain: Set<String>!
    var stringVariable: StringVariable!
    
    override func setUp() {
        stringVariableDomain = ["a", "b", "c"]
        stringVariable = StringVariable(name: "string", domain: stringVariableDomain)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        for stringValue in stringVariableDomain {
            XCTAssertTrue(stringVariable.canAssign(to: stringValue))
        }
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(stringVariable.canAssign(to: 4))
        XCTAssertFalse(stringVariable.canAssign(to: "e"))
    }
    
    func testAssignTo_possibleValue_getsAssigned() throws {
        for stringValue in stringVariableDomain {
            XCTAssertTrue(stringVariable.assign(to: stringValue))
            let stringValue = try XCTUnwrap(stringVariable.assignment)
            XCTAssertEqual(stringValue, stringValue)
        }
    }
    
    func testAssignTo_impossibleValue_notAssigned() throws {
        XCTAssertFalse(stringVariable.assign(to: "e"))
        XCTAssertNil(stringVariable.assignment)
        stringVariable.assign(to: "c")
        XCTAssertFalse(stringVariable.assign(to: "d"))
        let stringValue = try XCTUnwrap(stringVariable.assignment)
        XCTAssertEqual(stringValue, "c")
    }
    
    func testSetDomain_validDomain() {
        let newValidDomain = ["x", "y", "z"]
        stringVariable.setDomain(newDomain: newValidDomain)
        XCTAssertEqual(stringVariable.domain, Set(newValidDomain))
    }
    
    // TODO: put back after introducing errors messages
    /*
    func testSetDomain_invalidDomain_throwsError() {
        let invalidDomain = [1, 2, 3]
        XCTAssertThrowsError(stringVariable.setDomain(newDomain: invalidDomain))
        XCTAssertEqual(stringVariable.domain, stringVariableDomain)
    }
     */
    
    func testUnassign_assignmentSetToNil() throws {
        stringVariable.assign(to: "b")
        let stringValue = try XCTUnwrap(stringVariable.assignment)
        XCTAssertEqual(stringValue, "b")
        stringVariable.unassign()
        XCTAssertNil(stringVariable.assignment)
    }
}
