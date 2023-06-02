@testable import Engine
import XCTest

final class LinearCombinationConstraintTests: XCTestCase {
    var intVariableA: IntVariable!
    var floatVariableB: FloatVariable!
    var floatVariableC: FloatVariable!

    var ternaryVariable: TernaryVariable!

    var variableSet: SetOfVariables!

    var linearCombinationConstraint: LinearCombinationConstraint!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        floatVariableB = FloatVariable(name: "floatB", domain: Set([4.123, 5.456, 6.789]))
        floatVariableC = FloatVariable(name: "floatC", domain: Set([7.987, 8.654, 9.321]))

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: floatVariableB,
                                          variableC: floatVariableC)

        variableSet = SetOfVariables(from: [intVariableA, floatVariableB, floatVariableC, ternaryVariable])

        linearCombinationConstraint = LinearCombinationConstraint(ternaryVariable,
                                                                  scaleA: 1,
                                                                  scaleB: 2,
                                                                  scaleC: -1,
                                                                  add: -7.591)
    }

    // MARK: testing methods/attributes inherited from Constraint
    func testVariableNames_returnsAllVariableNames() {
        let expectedVariableNames: [String] = [ternaryVariable.name]
        let actualVariableNames = linearCombinationConstraint.variableNames
        XCTAssertTrue(actualVariableNames == expectedVariableNames)
    }

    func testContainsAssignedVariable_allUnassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.containsAssignedVariable(state: variableSet))
    }

    func testContainsAssignedVariable_someAssigned_returnsTrue() {
        let floatB: Float = 5.456
        let floatC: Float = 9.321
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        variableSet.assign(ternaryVariable.name, to: newAssignment)
        XCTAssertTrue(variableSet.isAssigned(ternaryVariable.name))

        XCTAssertTrue(linearCombinationConstraint.containsAssignedVariable(state: variableSet))
    }

    // MARK: tests for isSatisfied
    func testIsSatisfied_unassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_doesNotSatisfyLinearCombination_returnsFalse() {
        let floatB: Float = 4.123
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertFalse(linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    func testIsSatisfied_satisfiesLinearCombination_returnsTrue() {
        let floatB: Float = 6.789
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertTrue(linearCombinationConstraint.isSatisfied(state: variableSet))
    }

    // MARK: tests for isViolated
    func testIsViolated_unassigned_returnsFalse() {
        XCTAssertFalse(linearCombinationConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_satisfiesLinearCombination_returnsFalse() {
        let floatB: Float = 6.789
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertFalse(linearCombinationConstraint.isViolated(state: variableSet))
    }

    func testIsViolated_doesNotSatisfyLinearCombination_returnsTrue() {
        let floatB: Float = 4.123
        let floatC: Float = 7.987
        let newAssignment = NaryVariableValueType(value: [1, floatB, floatC])
        variableSet.assign(ternaryVariable.name, to: newAssignment)
        let ternaryVariableAssignment = variableSet.getAssignment(ternaryVariable.name, type: TernaryVariable.self)
        XCTAssertEqual(ternaryVariableAssignment, newAssignment)

        XCTAssertTrue(linearCombinationConstraint.isViolated(state: variableSet))
    }

    // MARK: testing methods/attributes inherited from UnaryConstraint
    func testRestrictDomain_returnsCorrectlyRestrictedDomain() {
        let floatB: Float = 6.789
        let floatC: Float = 7.987

        // preparing expected result
        var copiedVariableSet = variableSet!
        let newAssignment = NaryVariableValueType(value: [2, floatB, floatC])
        copiedVariableSet.assign(ternaryVariable.name, to: newAssignment)
        let expectedTernaryVariableDomain = copiedVariableSet.getDomain(ternaryVariable.name, type: TernaryVariable.self)

        // getting result
        let restrictedVariableSet = linearCombinationConstraint.restrictDomain(state: variableSet)
        let actualTernaryVariableDomain = restrictedVariableSet.getDomain(ternaryVariable.name, type: TernaryVariable.self)

        XCTAssertEqual(actualTernaryVariableDomain, expectedTernaryVariableDomain)
    }
}
