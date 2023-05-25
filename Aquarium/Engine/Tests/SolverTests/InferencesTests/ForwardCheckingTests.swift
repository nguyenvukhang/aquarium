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

    var inferenceEngine: InferenceEngine!

    var engines: [InferenceEngine] = [InferenceEngine]()
    
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

        constraints = Constraints(allConstraints: allConstraints)

        inferenceEngine = ForwardChecking(variables: allVariables, constraints: constraints)




        let perms = Array<any Variable>.possibleAssignments(domains: [allVariables, allVariables, allVariables])
        let otherAllConstraints: [any Constraint] = [cGreaterThanA, aGreaterThanB]
        let newConstraints = Constraints(allConstraints: otherAllConstraints)

        for perm in perms {
            engines.append(ForwardChecking(variables: perm, constraints: constraints))
            engines.append(ForwardChecking(variables: perm, constraints: newConstraints))
        }
    }

    func testMakeNewInference_settingVarCTo4() {
        intVariableC.assignment = 4
        XCTAssertEqual(intVariableC.assignment, 4)

        /*
        let inference = inferenceEngine.makeNewInference()

        let inferredDomainA = inference.getDomain(for: intVariableA)
        let inferredDomainB = inference.getDomain(for: intVariableB)
        let inferredDomainC = inference.getDomain(for: intVariableC)

        let inferredDomainAAsSet = intVariableA.createValueTypeSet(from: inferredDomainA)
        let inferredDomainBAsSet = intVariableB.createValueTypeSet(from: inferredDomainB)
        let inferredDomainCAsSet = intVariableC.createValueTypeSet(from: inferredDomainC)

        let expectedDomainAAsSet = Set([1])
        let expectedDomainBAsSet = Set([1, 2, 3])
        let expectedDomainCAsSet = Set<Int>()

        XCTAssertEqual(inferredDomainAAsSet, expectedDomainAAsSet)
        XCTAssertEqual(inferredDomainBAsSet, expectedDomainBAsSet)
        XCTAssertEqual(inferredDomainCAsSet, expectedDomainCAsSet)
         */
        for engine in engines {
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

            XCTAssertEqual(inferredDomainAAsSet, expectedDomainAAsSet, "\(engine.variables)")
            XCTAssertEqual(inferredDomainBAsSet, expectedDomainBAsSet, "\(engine.variables)")
            XCTAssertEqual(inferredDomainCAsSet, expectedDomainCAsSet, "\(engine.variables)")
        }
    }
}
