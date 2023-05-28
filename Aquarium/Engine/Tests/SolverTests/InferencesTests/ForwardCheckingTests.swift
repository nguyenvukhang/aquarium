@testable import Engine
import XCTest

// TODO: test that ForwardChecking is deterministic using a larger test
final class ForwardCheckingTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    var aGreaterThanB: GreaterThanConstraint!
    var cGreaterThanA: GreaterThanConstraint!

    var constraints: Constraints!

    var inferenceEngines: [InferenceEngine] = [InferenceEngine]()
    
    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 4, 5]))
        intVariableB = IntVariable(name: "intB", domain: Set([1, 2, 3]))
        intVariableC = IntVariable(name: "intC", domain: Set([2, 3, 4, 5]))

        let allVariables: [any Variable] = [intVariableA,
                                            intVariableB,
                                            intVariableC]

        aGreaterThanB = GreaterThanConstraint(intVariableA, isGreaterThan: intVariableB)
        cGreaterThanA = GreaterThanConstraint(intVariableC, isGreaterThan: intVariableA)

        let allConstraints: [any Constraint] = [aGreaterThanB, cGreaterThanA]

        inferenceEngines = createAllEnginePermutations(allVariables: allVariables, allConstraints: allConstraints)
    }

    private func createAllEnginePermutations(allVariables: [any Variable],
                                             allConstraints: [any Constraint]) -> [any InferenceEngine] {
        var inferenceEngines = [any InferenceEngine]()

        let variablePermutations = Array<any Variable>.permutations(allVariables)
        let constraintPermutations = Array<any Constraint>.permutations(allConstraints)

        for variablePerm in variablePermutations {
            for constraintPerm in constraintPermutations {
                let constraints = Constraints(allConstraints: constraintPerm)
                inferenceEngines.append(ForwardChecking(variables: variablePerm, constraints: constraints))
            }
        }

        return inferenceEngines
    }

    func testMakeNewInference_settingVarCTo4() {
        intVariableC.assignment = 4
        XCTAssertEqual(intVariableC.assignment, 4)

        for engine in inferenceEngines {
            let inference = engine.makeNewInference()

            let inferredDomainA = inference.getDomain(for: intVariableA)
            let inferredDomainB = inference.getDomain(for: intVariableB)
            let inferredDomainC = inference.getDomain(for: intVariableC)

            let inferredDomainAAsSet = intVariableA.createValueTypeSet(from: inferredDomainA)
            let inferredDomainBAsSet = intVariableB.createValueTypeSet(from: inferredDomainB)
            let inferredDomainCAsSet = intVariableC.createValueTypeSet(from: inferredDomainC)

            let expectedDomainAAsSet = Set([1])
            let expectedDomainBAsSet = Set([1, 2, 3])
            let expectedDomainCAsSet = Set([4])

            XCTAssertEqual(inferredDomainAAsSet, expectedDomainAAsSet)
            XCTAssertEqual(inferredDomainBAsSet, expectedDomainBAsSet)
            XCTAssertEqual(inferredDomainCAsSet, expectedDomainCAsSet)
        }
    }
}
