@testable import Engine
import XCTest

// TODO: test that ForwardChecking is deterministic using a larger test
final class ForwardCheckingTests: XCTestCase {
    // Example used here:
    //     T W O
    // +   T W O
    // ----------
    //   F O U R
    // ----------

    var intVariableT: IntVariable!
    var intVariableW: IntVariable!
    var intVariableO: IntVariable!
    var intVariableF: IntVariable!
    var intVariableU: IntVariable!
    var intVariableR: IntVariable!
    var intVariableX: IntVariable!
    var intVariableY: IntVariable!
    var intVariableC1: IntVariable!
    var intVariableC2: IntVariable!

    var dualVariableO_R_C1: TernaryVariable!
    var dualVariableW_C1_X: TernaryVariable!
    var dualVariableU_C2_X: TernaryVariable!
    var dualVariableT_C2_Y: TernaryVariable!
    var dualVariableO_F_Y: TernaryVariable!

    var allVariables: [any Variable]!

    // TODO: add when testcases done
    // var variableSet: VariableSet!

    var auxillaryConstraintT: AuxillaryConstraint!
    var auxillaryConstraintW: AuxillaryConstraint!
    var auxillaryConstraintOa: AuxillaryConstraint!
    var auxillaryConstraintOb: AuxillaryConstraint!
    var auxillaryConstraintF: AuxillaryConstraint!
    var auxillaryConstraintU: AuxillaryConstraint!
    var auxillaryConstraintR: AuxillaryConstraint!
    var auxillaryConstraintXa: AuxillaryConstraint!
    var auxillaryConstraintXb: AuxillaryConstraint!
    var auxillaryConstraintYa: AuxillaryConstraint!
    var auxillaryConstraintYb: AuxillaryConstraint!
    var auxillaryConstraintC1a: AuxillaryConstraint!
    var auxillaryConstraintC1b: AuxillaryConstraint!
    var auxillaryConstraintC2a: AuxillaryConstraint!
    var auxillaryConstraintC2b: AuxillaryConstraint!

    var constraintO_R_C1: LinearCombinationConstraint!
    var constraintW_C1_X: LinearCombinationConstraint!
    var constraintU_C2_X: LinearCombinationConstraint!
    var constraintT_C2_Y: LinearCombinationConstraint!
    var constraintO_F_Y: LinearCombinationConstraint!

    var allConstraints: [any Constraint]!

    var inferenceEngines: [InferenceEngine]!

    override func setUp() {
        intVariableT = IntVariable(name: "T", domain: Set(1 ... 9))
        intVariableW = IntVariable(name: "W", domain: Set(0 ... 9))
        intVariableO = IntVariable(name: "O", domain: Set(0 ... 9))
        intVariableF = IntVariable(name: "F", domain: Set(1 ... 9))
        intVariableU = IntVariable(name: "U", domain: Set(0 ... 9))
        intVariableR = IntVariable(name: "R", domain: Set(0 ... 9))
        intVariableX = IntVariable(name: "X", domain: Set(0 ... 19))
        intVariableY = IntVariable(name: "Y", domain: Set(10 ... 99))
        intVariableC1 = IntVariable(name: "C1", domain: Set(0 ... 1))
        intVariableC2 = IntVariable(name: "C2", domain: Set(0 ... 1))

        dualVariableO_R_C1 = TernaryVariable(name: "O_R_C1",
                                             variableA: intVariableO,
                                             variableB: intVariableR,
                                             variableC: intVariableC1)
        dualVariableW_C1_X = TernaryVariable(name: "W_C1_X",
                                             variableA: intVariableW,
                                             variableB: intVariableC1,
                                             variableC: intVariableX)
        dualVariableU_C2_X = TernaryVariable(name: "U_C2_X",
                                             variableA: intVariableU,
                                             variableB: intVariableC2,
                                             variableC: intVariableX)
        dualVariableT_C2_Y = TernaryVariable(name: "T_C2_T",
                                             variableA: intVariableT,
                                             variableB: intVariableC2,
                                             variableC: intVariableY)
        dualVariableO_F_Y = TernaryVariable(name: "O_F_Y",
                                            variableA: intVariableO,
                                            variableB: intVariableF,
                                            variableC: intVariableY)

        allVariables = [intVariableT,
                        intVariableW,
                        intVariableO,
                        intVariableF,
                        intVariableU,
                        intVariableR,
                        intVariableX,
                        intVariableY,
                        intVariableC1,
                        intVariableC2,
                        dualVariableO_R_C1,
                        dualVariableW_C1_X,
                        dualVariableU_C2_X,
                        dualVariableT_C2_Y,
                        dualVariableO_F_Y]

        auxillaryConstraintT = AuxillaryConstraint(mainVariable: intVariableT,
                                                   dualVariable: dualVariableT_C2_Y)
        auxillaryConstraintW = AuxillaryConstraint(mainVariable: intVariableW,
                                                   dualVariable: dualVariableW_C1_X)
        auxillaryConstraintOa = AuxillaryConstraint(mainVariable: intVariableO,
                                                    dualVariable: dualVariableO_F_Y)
        auxillaryConstraintOb = AuxillaryConstraint(mainVariable: intVariableO,
                                                    dualVariable: dualVariableO_R_C1)
        auxillaryConstraintF = AuxillaryConstraint(mainVariable: intVariableF,
                                                   dualVariable: dualVariableO_F_Y)
        auxillaryConstraintU = AuxillaryConstraint(mainVariable: intVariableU,
                                                   dualVariable: dualVariableU_C2_X)
        auxillaryConstraintR = AuxillaryConstraint(mainVariable: intVariableR,
                                                   dualVariable: dualVariableO_R_C1)
        auxillaryConstraintXa = AuxillaryConstraint(mainVariable: intVariableX,
                                                    dualVariable: dualVariableW_C1_X)
        auxillaryConstraintXb = AuxillaryConstraint(mainVariable: intVariableX,
                                                    dualVariable: dualVariableU_C2_X)
        auxillaryConstraintYa = AuxillaryConstraint(mainVariable: intVariableY,
                                                    dualVariable: dualVariableT_C2_Y)
        auxillaryConstraintYb = AuxillaryConstraint(mainVariable: intVariableY,
                                                    dualVariable: dualVariableO_F_Y)
        auxillaryConstraintC1a = AuxillaryConstraint(mainVariable: intVariableC1,
                                                     dualVariable: dualVariableO_R_C1)
        auxillaryConstraintC1b = AuxillaryConstraint(mainVariable: intVariableC1,
                                                     dualVariable: dualVariableW_C1_X)
        auxillaryConstraintC2a = AuxillaryConstraint(mainVariable: intVariableC2,
                                                     dualVariable: dualVariableU_C2_X)
        auxillaryConstraintC2b = AuxillaryConstraint(mainVariable: intVariableC2,
                                                     dualVariable: dualVariableT_C2_Y)

        constraintO_R_C1 = LinearCombinationConstraint(dualVariableO_R_C1,
                                                       scaleA: 2,
                                                       scaleB: -1,
                                                       scaleC: -10)
        constraintW_C1_X = LinearCombinationConstraint(dualVariableW_C1_X,
                                                       scaleA: 2,
                                                       scaleB: 1,
                                                       scaleC: -1)
        constraintU_C2_X = LinearCombinationConstraint(dualVariableU_C2_X,
                                                       scaleA: 1,
                                                       scaleB: 10,
                                                       scaleC: -1)
        constraintT_C2_Y = LinearCombinationConstraint(dualVariableT_C2_Y,
                                                       scaleA: 2,
                                                       scaleB: 1,
                                                       scaleC: -1)
        constraintO_F_Y = LinearCombinationConstraint(dualVariableO_F_Y,
                                                       scaleA: 1,
                                                       scaleB: 10,
                                                       scaleC: -1)

        allConstraints = [auxillaryConstraintT,
                          auxillaryConstraintW,
                          auxillaryConstraintOa,
                          auxillaryConstraintOb,
                          auxillaryConstraintF,
                          auxillaryConstraintU,
                          auxillaryConstraintR,
                          auxillaryConstraintXa,
                          auxillaryConstraintXb,
                          auxillaryConstraintYa,
                          auxillaryConstraintYb,
                          auxillaryConstraintC1a,
                          auxillaryConstraintC1b,
                          auxillaryConstraintC2a,
                          auxillaryConstraintC2b,
                          constraintO_R_C1,
                          constraintW_C1_X,
                          constraintU_C2_X,
                          constraintT_C2_Y,
                          constraintO_F_Y]

        inferenceEngines = createAllEnginePermutations(allVariables: allVariables,
                                                       allConstraints: allConstraints)
    }

    private func createAllEnginePermutations(allVariables: [any Variable],
                                             allConstraints: [any Constraint]) -> [any InferenceEngine] {
        var inferenceEngines = [any InferenceEngine]()

        let variablePermutations = Array<any Variable>.permutations(allVariables)
        let constraintPermutations = Array<any Constraint>.permutations(allConstraints)

        for variablePerm in variablePermutations {
            for constraintPerm in constraintPermutations {
                let constraintSet = ConstraintSet(allConstraints: constraintPerm)
                inferenceEngines.append(ForwardChecking(variables: variablePerm,
                                                        constraintSet: constraintSet))
            }
        }

        return inferenceEngines
    }

    func testMakeNewInference_settingFTo1() {
        intVariableF.assignment = 1
        XCTAssertEqual(intVariableF.assignment, 1)
        intVariableO.assignment = 6
        XCTAssertEqual(intVariableO.assignment, 6)

        for engine in inferenceEngines {
            let inference = engine.makeNewInference()

            let inferredDomainT = intVariableT.createValueTypeSet(from: inference.getDomain(for: intVariableT))
            let inferredDomainW = intVariableW.createValueTypeSet(from: inference.getDomain(for: intVariableW))
            let inferredDomainO = intVariableO.createValueTypeSet(from: inference.getDomain(for: intVariableO))
            let inferredDomainF = intVariableF.createValueTypeSet(from: inference.getDomain(for: intVariableF))
            let inferredDomainU = intVariableU.createValueTypeSet(from: inference.getDomain(for: intVariableU))
            let inferredDomainR = intVariableR.createValueTypeSet(from: inference.getDomain(for: intVariableR))
            let inferredDomainX = intVariableX.createValueTypeSet(from: inference.getDomain(for: intVariableX))
            let inferredDomainY = intVariableY.createValueTypeSet(from: inference.getDomain(for: intVariableY))
            let inferredDomainC1 = intVariableC1.createValueTypeSet(from: inference.getDomain(for: intVariableC1))
            let inferredDomainC2 = intVariableC2.createValueTypeSet(from: inference.getDomain(for: intVariableC2))
            let inferredDomainO_R_C1 = dualVariableO_R_C1.createValueTypeSet(from: inference.getDomain(for: dualVariableO_R_C1))
            let inferredDomainW_C1_X = dualVariableW_C1_X.createValueTypeSet(from: inference.getDomain(for: dualVariableW_C1_X))
            let inferredDomainU_C2_X = dualVariableU_C2_X.createValueTypeSet(from: inference.getDomain(for: dualVariableU_C2_X))
            let inferredDomainT_C2_Y = dualVariableT_C2_Y.createValueTypeSet(from: inference.getDomain(for: dualVariableT_C2_Y))
            let inferredDomainO_F_Y = dualVariableO_F_Y.createValueTypeSet(from: inference.getDomain(for: dualVariableO_F_Y))

            let expectedDomainT = Set(1 ... 9)
            let expectedDomainW = Set(0 ... 9)
            let expectedDomainO = Set([6])
            // only F expected to change
            let expectedDomainF = Set([1])
            let expectedDomainU = Set(0 ... 9)
            let expectedDomainR = Set(0 ... 9)
            let expectedDomainX = Set(0 ... 19)
            let expectedDomainY = Set(10 ... 99)
            let expectedDomainC1 = Set(0 ... 1)
            let expectedDomainC2 = Set(0 ... 1)
            let expectedDomainO_R_C1 = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainO),
                                               Array(expectedDomainR),
                                               Array(expectedDomainC1)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainW_C1_X = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainW),
                                               Array(expectedDomainC1),
                                               Array(expectedDomainX)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainU_C2_X = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainU),
                                               Array(expectedDomainC2),
                                               Array(expectedDomainX)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainT_C2_Y = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainT),
                                               Array(expectedDomainC2),
                                               Array(expectedDomainY)])
                    .map({ NaryVariableValueType(value: $0) }))
            let expectedDomainO_F_Y = Set(Array<any Value>
                .possibleAssignments(domains: [Array(expectedDomainO),
                                               Array(expectedDomainF),
                                               Array(expectedDomainY)])
                    .map({ NaryVariableValueType(value: $0) }))

            XCTAssertEqual(inferredDomainT, expectedDomainT)
            XCTAssertEqual(inferredDomainW, expectedDomainW)
            XCTAssertEqual(inferredDomainO, expectedDomainO)
            XCTAssertEqual(inferredDomainF, expectedDomainF)
            XCTAssertEqual(inferredDomainU, expectedDomainU)
            XCTAssertEqual(inferredDomainR, expectedDomainR)
            XCTAssertEqual(inferredDomainX, expectedDomainX)
            XCTAssertEqual(inferredDomainY, expectedDomainY)
            XCTAssertEqual(inferredDomainC1, expectedDomainC1)
            XCTAssertEqual(inferredDomainC2, expectedDomainC2)
            XCTAssertEqual(inferredDomainO_R_C1, expectedDomainO_R_C1)
            XCTAssertEqual(inferredDomainW_C1_X, expectedDomainW_C1_X)
            XCTAssertEqual(inferredDomainU_C2_X, expectedDomainU_C2_X)
            XCTAssertEqual(inferredDomainT_C2_Y, expectedDomainT_C2_Y)
            XCTAssertEqual(inferredDomainO_F_Y, expectedDomainO_F_Y)
        }
    }
}
