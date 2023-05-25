@testable import Engine

import XCTest

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class IntVariableTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
    }
    
    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(intVariable.domain, intVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        intVariable.assignment = 1
        XCTAssertEqual(intVariable.domain, [1])
    }

    func testDomain_setter_validNewDomain_reflectedInDomainUndoStack() {
        // set to [1, 2]
        var newDomain = Set([1, 2])
        intVariable.domain = newDomain
        
        XCTAssertEqual(intVariable.domain, newDomain)
        
        // check that previous is [1, 2, 3]
        var expectedPreviousDomain = intVariableDomain
        var previousDomain = intVariable.domainUndoStack.peek()
        
        XCTAssertEqual(previousDomain, expectedPreviousDomain)
        
        // set to [1]
        newDomain = Set([1])
        intVariable.domain = newDomain
        
        XCTAssertEqual(intVariable.domain, newDomain)
        
        // check that previous is [1, 2]
        expectedPreviousDomain = Set([1, 2])
        previousDomain = intVariable.domainUndoStack.peek()
        
        XCTAssertEqual(previousDomain, expectedPreviousDomain)
    }
    
    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {
        
    }
    
    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(intVariable.assignment)
    }

    func testAssignment_setter_validNewAssignment() {
        for domainValue in intVariableDomain {
            intVariable.unassign()
            intVariable.assignment = domainValue
            XCTAssertEqual(intVariable.assignment, domainValue)
        }
    }
    
    func testAssignment_setter_currentAssignmentNotNil_throwsError() {
        
    }
    
    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {
        
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        for intValue in intVariableDomain {
            XCTAssertTrue(intVariable.canAssign(to: intValue))
        }
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(intVariable.canAssign(to: 4))
        XCTAssertFalse(intVariable.canAssign(to: "success"))
        XCTAssertFalse(intVariable.canAssign(to: true))
    }
    
    func testAssignTo_possibleValue_getsAssigned() throws {
        for domainValue in intVariableDomain {
            intVariable.unassign()
            intVariable.assign(to: domainValue)
            let domainValue = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(domainValue, domainValue)
        }
    }
    
    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        XCTAssertFalse(intVariable.assign(to: 4))
        XCTAssertNil(intVariable.assignment)
        intVariable.assign(to: 3)
        XCTAssertFalse(intVariable.assign(to: 5))
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 3)
         */
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomain = [1, 2]
        XCTAssertTrue(intVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [Int]()
        XCTAssertTrue(intVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_setter_notSubsetOfCurrentDomain_returnsFalse() {
        let newDomain = [2, 3, 4]
        XCTAssertFalse(intVariable.canSetDomain(to: newDomain))
    }

    func testUndoSetDomain_oneLevel() {
        // set domain to [1, 2]
        let newDomain = Set([1, 2])
        intVariable.domain = newDomain
        XCTAssertEqual(intVariable.domain, newDomain)
        
        let expectedPreviousDomain = intVariableDomain
        intVariable.undoSetDomain()
        
        XCTAssertEqual(intVariable.domain, expectedPreviousDomain)
    }
    
    func testUndoSetDomain_twoLevels() {
        // set domain to [1, 2]
        var newDomain = Set([1, 2])
        intVariable.domain = newDomain
        XCTAssertEqual(intVariable.domain, newDomain)
        
        // set domain to [2]
        newDomain = Set([2])
        intVariable.domain = newDomain
        XCTAssertEqual(intVariable.domain, newDomain)
        
        // undo to [1, 2]
        var expectedPreviousDomain = Set([1, 2])
        intVariable.undoSetDomain()
        XCTAssertEqual(intVariable.domain, expectedPreviousDomain)
        
        // undo to [1, 2, 3]
        expectedPreviousDomain = intVariableDomain
        intVariable.undoSetDomain()
        XCTAssertEqual(intVariable.domain, expectedPreviousDomain)
    }
    
    func testUnassign_assignmentSetToNil() throws {
        intVariable.assignment = 2
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
    }
}
