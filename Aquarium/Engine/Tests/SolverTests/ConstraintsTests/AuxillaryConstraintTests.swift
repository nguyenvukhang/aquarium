@testable import Engine
import XCTest

final class AuxillaryConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var strVariableC: StringVariable!

    var allAssociatedVariables: [any Variable]!
    var allAssociatedDomains: [[any Value]]!

    var dualVariable: TernaryVariable!
    var expectedDualVariableDomain: Set<NaryVariableValueType>!

    var auxillaryConstraintA: AuxillaryConstraint!
    var auxillaryConstraintB: AuxillaryConstraint!
    var auxillaryConstraintC: AuxillaryConstraint!

    var allConstraints: [any Constraint]!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        intVariableB = IntVariable(name: "intB", domain: Set([4, 5, 6]))
        strVariableC = StringVariable(name: "strC", domain: Set(["x", "y", "z"]))

        allAssociatedVariables = [intVariableA, intVariableB, strVariableC]
        allAssociatedDomains = [intVariableA.domainAsArray, intVariableB.domainAsArray, strVariableC.domainAsArray]

        dualVariable = TernaryVariable(name: "dual",
                                       variableA: intVariableA,
                                       variableB: intVariableB,
                                       variableC: strVariableC)

        let possibleAssignments = Array<any Value>.possibleAssignments(domains: allAssociatedDomains)
        expectedDualVariableDomain = Set(possibleAssignments.map( {NaryVariableValueType(value: $0) }))

        auxillaryConstraintA = AuxillaryConstraint(mainVariable: intVariableA, dualVariable: dualVariable)
        auxillaryConstraintB = AuxillaryConstraint(mainVariable: intVariableB, dualVariable: dualVariable)
        auxillaryConstraintC = AuxillaryConstraint(mainVariable: strVariableC, dualVariable: dualVariable)

        allConstraints = [auxillaryConstraintA, auxillaryConstraintB, auxillaryConstraintC]
    }

    func testVariables_returnsAllVariables() {
        for idx in 0 ..< allConstraints.count {
            let constraint = allConstraints[idx]
            let mainVariable = allAssociatedVariables[idx]
            let expectedVariables: [any Variable] = [mainVariable, dualVariable]

            let actualVariables = constraint.variables

            XCTAssertTrue(actualVariables.isEqual(expectedVariables))
        }
    }

    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.containsAssignedVariable)
        }
    }

    func testContainsAssignedVariable_mainVariableAssigned_returnsFalse() {
        // auxillaryConstraintA
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        XCTAssertTrue(auxillaryConstraintA.containsAssignedVariable)

        // auxillaryConstraintB
        intVariableB.assignment = 5
        XCTAssertEqual(intVariableB.assignment, 5)
        XCTAssertTrue(auxillaryConstraintB.containsAssignedVariable)

        // auxillaryConstraintC
        strVariableC.assignment = "y"
        XCTAssertEqual(strVariableC.assignment, "y")
        XCTAssertTrue(auxillaryConstraintC.containsAssignedVariable)
    }

    func testContainsAssignedVariable_dualVariableAssigned_returnsFalse() {
        dualVariable.assignment = NaryVariableValueType(value: [2, 5, "z"])

        for constraint in allConstraints {
            XCTAssertTrue(constraint.containsAssignedVariable)
        }
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_bothUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied)
        }
    }

    func testIsSatisfied_onlyMainVariableAssigned_returnsFalse() {
        // auxillaryConstraintA
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintA.isSatisfied)

        // auxillaryConstraintB
        intVariableB.assignment = 5
        XCTAssertEqual(intVariableB.assignment, 5)
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintB.isSatisfied)

        // auxillaryConstraintC
        strVariableC.assignment = "z"
        XCTAssertEqual(strVariableC.assignment, "z")
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintC.isSatisfied)
    }

    func testIsSatisfied_onlyDualVariableAssigned_returnsFalse() {
        dualVariable.assignment = NaryVariableValueType(value: [1, 6, "y"])

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied)
        }
    }

    func testIsSatisfied_allVariablesNotEqualDualVariable_allReturnFalse() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 4
        XCTAssertEqual(intVariableB.assignment, 4)
        strVariableC.assignment = "x"
        XCTAssertEqual(strVariableC.assignment, "x")

        dualVariable.assignment = NaryVariableValueType(value: [2, 6, "y"])

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isSatisfied)
        }
    }

    func testIsSatisfied_someVariablesEqualDualVariable_equalAssignmentsReturnTrue() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 4
        XCTAssertEqual(intVariableB.assignment, 4)
        strVariableC.assignment = "x"
        XCTAssertEqual(strVariableC.assignment, "x")

        dualVariable.assignment = NaryVariableValueType(value: [1, 6, "x"])

        XCTAssertTrue(auxillaryConstraintA.isSatisfied)
        XCTAssertFalse(auxillaryConstraintB.isSatisfied)
        XCTAssertTrue(auxillaryConstraintC.isSatisfied)
    }

    // MARK: tests for isViolated
    func testIsViolated_bothUnassigned_returnsFalse() {
        for constraint in allConstraints {
            XCTAssertFalse(constraint.isViolated)
        }
    }

    func testIsViolated_onlyMainVariableAssigned_returnsFalse() {
        // auxillaryConstraintA
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintA.isViolated)

        // auxillaryConstraintB
        intVariableB.assignment = 5
        XCTAssertEqual(intVariableB.assignment, 5)
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintB.isViolated)

        // auxillaryConstraintC
        strVariableC.assignment = "z"
        XCTAssertEqual(strVariableC.assignment, "z")
        XCTAssertFalse(dualVariable.isAssigned)
        XCTAssertFalse(auxillaryConstraintC.isViolated)
    }

    func testIsViolated_onlyDualVariableAssigned_returnsFalse() {
        dualVariable.assignment = NaryVariableValueType(value: [1, 6, "y"])

        for constraint in allConstraints {
            XCTAssertFalse(constraint.isViolated)
        }
    }

    func testIsViolated_someVariablesEqualDualVariable_unequalAssignmentsReturnTrue() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 4
        XCTAssertEqual(intVariableB.assignment, 4)
        strVariableC.assignment = "x"
        XCTAssertEqual(strVariableC.assignment, "x")

        dualVariable.assignment = NaryVariableValueType(value: [1, 6, "x"])

        XCTAssertFalse(auxillaryConstraintA.isViolated)
        XCTAssertTrue(auxillaryConstraintB.isViolated)
        XCTAssertFalse(auxillaryConstraintC.isViolated)
    }

    func testIsViolated_allVariablesNotEqualDualVariable_allReturnTrue() {
        intVariableA.assignment = 1
        XCTAssertEqual(intVariableA.assignment, 1)
        intVariableB.assignment = 4
        XCTAssertEqual(intVariableB.assignment, 4)
        strVariableC.assignment = "x"
        XCTAssertEqual(strVariableC.assignment, "x")

        dualVariable.assignment = NaryVariableValueType(value: [2, 6, "y"])

        for constraint in allConstraints {
            XCTAssertTrue(constraint.isViolated)
        }
    }
}
