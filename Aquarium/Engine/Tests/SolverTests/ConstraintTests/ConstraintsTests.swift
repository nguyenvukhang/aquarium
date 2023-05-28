@testable import Engine
import XCTest

final class ConstraintsTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    var aGreaterThanB: GreaterThanConstraint!
    var cGreaterThanA: GreaterThanConstraint!

    var constraints: Constraints!
    
    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: [1, 3, 4, 5])
        intVariableB = IntVariable(name: "intB", domain: [1, 2, 3])
        intVariableC = IntVariable(name: "intC", domain: [2, 3, 4, 5])

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
        cGreaterThanA = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableA)

        constraints = Constraints(allConstraints: [aGreaterThanB, cGreaterThanA])
    }

    func testAllConstraints_returnsAllConstraints() {
        let expectedConstraintArray = [aGreaterThanB, cGreaterThanA]
        let actualConstraintArray = constraints.allConstraints

        XCTAssertEqual(actualConstraintArray.count, expectedConstraintArray.count)
        for expectedConstraint in expectedConstraintArray {
            XCTAssertTrue(actualConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testAdd_constraintGetsAdded() {
        let newConstraint = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableB)
        constraints.add(constraint: newConstraint)

        let expectedConstraintArray = [aGreaterThanB, cGreaterThanA, newConstraint]
        let actualConstraintArray = constraints.allConstraints

        XCTAssertEqual(actualConstraintArray.count, expectedConstraintArray.count)
        for expectedConstraint in expectedConstraintArray {
            XCTAssertTrue(actualConstraintArray.contains(where: { $0.isEqual(expectedConstraint) }))
        }
    }

    func testAllSatisfied_allNotSatisfied_returnsFalse() {
        intVariableA.assignment = 3
        intVariableB.assignment = 3
        intVariableC.assignment = 2
        XCTAssertFalse(aGreaterThanB.isSatisfied)
        XCTAssertFalse(cGreaterThanA.isSatisfied)

        XCTAssertFalse(constraints.allSatisfied)
    }

    func testAllSatisfied_oneNotSatisfied_returnsFalse() {
        intVariableA.assignment = 5
        intVariableB.assignment = 2
        XCTAssertTrue(aGreaterThanB.isSatisfied)

        XCTAssertFalse(constraints.allSatisfied)
    }

    func testAllSatisfied_allSatisfied_returnsTrue() {
        intVariableA.assignment = 3
        intVariableB.assignment = 2
        intVariableC.assignment = 4
        XCTAssertTrue(aGreaterThanB.isSatisfied)
        XCTAssertTrue(cGreaterThanA.isSatisfied)

        XCTAssertTrue(constraints.allSatisfied)
    }
}
