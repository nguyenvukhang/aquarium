@testable import Engine
import XCTest

final class LinearCombinationConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var linearCombinationConstraint: LinearCombinationConstraint!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 1,
                                                                  scaleB: 2,
                                                                  scaleC: -1,
                                                                  add: -7.591)
    }

    func testVariables_returnsAllVariables() {
        let expectedVariables: [any Variable] = [ternaryVariable]
        let actualVariables = linearCombinationConstraint.variables
        XCTAssertTrue(actualVariables.isEqual(expectedVariables))
    }

    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.containsAssignedVariable)
    }

    func testContainsAssignedVariable_someAssigned_returnsTrue() {
        let floatA: Float = 5.456
        let floatB: Float = 9.321
        let assignment = NaryVariableValueType(value: [1, floatA, floatB])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.assignment, assignment)

        XCTAssertTrue(linearCombinationConstraint.containsAssignedVariable)
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_unassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.isSatisfied)
    }

    func testIsSatisfied_doesNotSatisfyLinearCombination_returnsFalse() {
        let floatA: Float = 4.123
        let floatB: Float = 7.987
        let assignment = NaryVariableValueType(value: [1, floatA, floatB])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.assignment, assignment)

        XCTAssertFalse(linearCombinationConstraint.isSatisfied)
    }

    func testIsSatisfied_satisfiesLinearCombination_returnsTrue() {
        let floatA: Float = 6.789
        let floatB: Float = 7.987
        let assignment = NaryVariableValueType(value: [2, floatA, floatB])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.assignment, assignment)

        XCTAssertTrue(linearCombinationConstraint.isSatisfied)
    }

    // MARK: tests for isViolated
    func testIsViolated_unassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.isViolated)
    }

    func testIsViolated_satisfiesLinearCombination_returnsFalse() {
        let floatA: Float = 6.789
        let floatB: Float = 7.987
        let assignment = NaryVariableValueType(value: [2, floatA, floatB])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.assignment, assignment)

        XCTAssertFalse(linearCombinationConstraint.isViolated)
    }

    func testIsViolated_doesNotSatisfyLinearCombination_returnsTrue() {
        let floatA: Float = 4.123
        let floatB: Float = 7.987
        let assignment = NaryVariableValueType(value: [1, floatA, floatB])
        ternaryVariable.assignment = assignment
        XCTAssertEqual(ternaryVariable.assignment, assignment)

        XCTAssertTrue(linearCombinationConstraint.isViolated)
    }
}
