@testable import Engine

import XCTest

final class GreaterThanConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!

    var aGreaterThanBConstraint: GreaterThanConstraint!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: [1, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])

        aGreaterThanBConstraint = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
    }

    func testVariables_returnsAllVariables() {
        let expectedVariables = [intVariableA, intVariableB]
        let actualVariables = aGreaterThanBConstraint.variables
        XCTAssertEqual(actualVariables.count, expectedVariables.count)
        for expectedVariable in expectedVariables {
            XCTAssertTrue(actualVariables.contains(where: { $0 === expectedVariable}))
        }
    }

    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(aGreaterThanBConstraint.containsAssignedVariable)
    }

    func testContainsAssignedVariable_someAssigned_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)

        XCTAssertTrue(aGreaterThanBConstraint.containsAssignedVariable)

        intVariableB.assignment = 2
        XCTAssertEqual(intVariableB.assignment, 2)
        
        XCTAssertTrue(aGreaterThanBConstraint.containsAssignedVariable)
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        XCTAssertFalse(aGreaterThanBConstraint.isSatisfied)
    }

    func testIsSatisfied_oneUnassigned_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        XCTAssertFalse(intVariableB.isAssigned)

        XCTAssertFalse(aGreaterThanBConstraint.isSatisfied)
    }

    func testIsSatisfied_aLessThanB_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 2
        XCTAssertEqual(intVariableB.assignment, 2)

        XCTAssertFalse(aGreaterThanBConstraint.isSatisfied)
    }

    func testIsSatisfied_aEqualToB_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 1
        XCTAssertEqual(intVariableB.assignment, 1)

        XCTAssertFalse(aGreaterThanBConstraint.isSatisfied)
    }

    func testIsSatisfied_aGreaterThanB_returnsTrue() {
        intVariableA.assignment = 4
        XCTAssertEqual(intVariableA.assignment, 4)
        intVariableB.assignment = 1
        XCTAssertEqual(intVariableB.assignment, 1)

        XCTAssertTrue(aGreaterThanBConstraint.isSatisfied)
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() {
        XCTAssertFalse(aGreaterThanBConstraint.isViolated)
    }

    func testIsViolated_oneUnassigned_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        XCTAssertFalse(intVariableB.isAssigned)

        XCTAssertFalse(aGreaterThanBConstraint.isViolated)
    }

    func testIsViolated_aGreaterThanB_returnsFalse() {
        intVariableA.assignment = 4
        XCTAssertEqual(intVariableA.assignment, 4)
        intVariableB.assignment = 1
        XCTAssertEqual(intVariableB.assignment, 1)

        XCTAssertFalse(aGreaterThanBConstraint.isViolated)
    }

    func testIsViolated_aLessThanB_returnsTrue() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 2
        XCTAssertEqual(intVariableB.assignment, 2)

        XCTAssertTrue(aGreaterThanBConstraint.isViolated)
    }

    func testIsViolated_aEqualToB_returnsTrue() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 1
        XCTAssertEqual(intVariableB.assignment, 1)

        XCTAssertTrue(aGreaterThanBConstraint.isViolated)
    }
}
