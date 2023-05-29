@testable import Engine
import XCTest

final class TernaryVariableTests: XCTestCase {
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var strVariableC: StringVariable!

    var allAssociatedVariables: [any Variable]!
    var allAssociatedDomains: [[any Value]]!

    var ternaryVariable: TernaryVariable!
    var expectedTernaryVariableDomain: Set<NaryVariableValueType>!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        intVariableB = IntVariable(name: "intB", domain: Set([4, 5, 6]))
        strVariableC = StringVariable(name: "strC", domain: Set(["x", "y", "z"]))

        allAssociatedVariables = [intVariableA, intVariableB, strVariableC]
        allAssociatedDomains = [intVariableA.domainAsArray, intVariableB.domainAsArray, strVariableC.domainAsArray]

        ternaryVariable = TernaryVariable(name: "ternary",
                                          variableA: intVariableA,
                                          variableB: intVariableB,
                                          variableC: strVariableC)

        let possibleAssignments = Array<any Value>.possibleAssignments(domains: allAssociatedDomains)
        expectedTernaryVariableDomain = Set(possibleAssignments.map( {NaryVariableValueType(value: $0) }))
    }

    // MARK: Testing methods/attributes defined in TernaryVariable
    func testCopy_returnsExactCopyButNotSameInstance() {
        let copiedTernaryVariable = ternaryVariable.copy()
        XCTAssertEqual(ternaryVariable, copiedTernaryVariable)
        XCTAssertFalse(ternaryVariable === copiedTernaryVariable)
    }

    // MARK: Testing methods/attributes inherited from NaryVariable
    func testAssociatedDomains() {
        let expectedAssociatedDomains = allAssociatedVariables.map({ $0.domainAsArray })
        let actualAssociatedDomains = ternaryVariable.associatedDomains

        XCTAssertTrue(actualAssociatedDomains.isEqual(expectedAssociatedDomains))
    }

    func testIsAssociated_associatedVariable_returnsTrue() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertTrue(ternaryVariable.isAssociated(with: associatedVariable))
        }
    }

    func testIsAssociated_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.isAssociated(with: nonAssociatedVariable))
    }

    func testAssignmentSatisfied_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: nonAssociatedVariable))
    }

    func testAssignmentSatisfied_bothUnassigned_returnsFalse() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
        }
    }

    func testAssignmentSatisfied_ternaryVariableAssigned_mainVariableUnassigned_returnsFalse() {
        for domainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = domainValue
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                associatedVariable.assign(to: domainValue)
                XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVariable))
                associatedVariable.unassign()
            }
        }
    }

    func testAssignmentSatisfied_bothAssignedDifferently_returnsFalse() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                let associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    associatedVar.assign(to: associatedVarDomainValue)
                    XCTAssertFalse(ternaryVariable.assignmentSatisfied(for: associatedVar))
                    associatedVar.unassign()
                }
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentSatisfied_bothAssignedSame_returnsTrue() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                let associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                associatedVar.assign(to: correctAssociatedVarAssignment)
                XCTAssertTrue(ternaryVariable.assignmentSatisfied(for: associatedVar))
                associatedVar.unassign()
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_nonAssociatedVariable_returnsFalse() {
        let nonAssociatedVariable = IntVariable(name: "nonAssociatedInt", domain: Set([7, 8, 9]))
        XCTAssertFalse(ternaryVariable.assignmentViolated(for: nonAssociatedVariable))
    }

    func testAssignmentViolated_bothUnassigned_returnsFalse() {
        for associatedVariable in allAssociatedVariables {
            XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
        }
    }

    func testAssignmentViolated_ternaryVariableAssigned_mainVariableUnassigned_returnsFalse() {
        for domainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = domainValue
            for associatedVariable in allAssociatedVariables {
                // associatedVariable remains unassigned
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_ternaryVariableUnassigned_mainVariableAssigned_returnsFalse() {
        // ternayVariable remains unassigned
        for associatedVariable in allAssociatedVariables {
            for domainValue in associatedVariable.domainAsArray {
                // assign associatedVariable
                XCTAssertTrue(associatedVariable.canAssign(to: domainValue))
                associatedVariable.assign(to: domainValue)
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVariable))
                associatedVariable.unassign()
            }
        }
    }

    func testAssignmentViolated_bothAssignedSame_returnsFalse() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                let associatedVar = allAssociatedVariables[idx]
                let correctAssociatedVarAssignment = ternaryVarDomainValue[idx]
                // assign associatedVariable (but only with ternaryVarDomainValue[idx])
                XCTAssertTrue(associatedVar.canAssign(to: correctAssociatedVarAssignment))
                associatedVar.assign(to: correctAssociatedVarAssignment)
                XCTAssertFalse(ternaryVariable.assignmentViolated(for: associatedVar))
                associatedVar.unassign()
            }
            ternaryVariable.unassign()
        }
    }

    func testAssignmentViolated_bothAssignedDifferently_returnsTrue() {
        for ternaryVarDomainValue in ternaryVariable.domain {
            // assign ternaryVariable
            ternaryVariable.assignment = ternaryVarDomainValue
            for idx in 0 ..< allAssociatedVariables.count {
                let associatedVar = allAssociatedVariables[idx]
                for associatedVarDomainValue in associatedVar.domainAsArray
                where !associatedVarDomainValue.isEqual(ternaryVarDomainValue[idx]) {
                    // assign associatedVariable (but only with some value not equal to ternaryVarDomainValue[idx])
                    XCTAssertTrue(associatedVar.canAssign(to: associatedVarDomainValue))
                    associatedVar.assign(to: associatedVarDomainValue)
                    XCTAssertTrue(ternaryVariable.assignmentViolated(for: associatedVar))
                    associatedVar.unassign()
                }
            }
            ternaryVariable.unassign()
        }
    }

    func testCreateInternalDomain() {
        let associatedDomainA: [any Value] = [1, 2]
        let associatedDomainB: [any Value] = [4, 5]
        let associatedDomainC: [any Value] = ["x", "y"]

        let associatedDomains: [[any Value]] = [associatedDomainA, associatedDomainB, associatedDomainC]

        let possibleAssignments: [[any Value]] = [[1, 4, "x"],
                                                  [1, 4, "y"],
                                                  [1, 5, "x"],
                                                  [1, 5, "y"],
                                                  [2, 4, "x"],
                                                  [2, 4, "y"],
                                                  [2, 5, "x"],
                                                  [2, 5, "y"]]

        let expectedDomain = Set(possibleAssignments.map( {NaryVariableValueType(value: $0) }))
        let actualDomain = TernaryVariable.createInternalDomain(from: associatedDomains)

        XCTAssertEqual(actualDomain, expectedDomain)
    }

    func testGetAssociatedDomains() throws {
        let intVariableD = IntVariable(name: "intD", domain: Set([11, 22, 33]))
        let intVariableE = IntVariable(name: "intE", domain: Set([44, 55, 66]))
        let strVariableF = StringVariable(name: "strF", domain: Set(["xx", "yy", "zz"]))
        let newAssociatedVariables: [any Variable] = [intVariableD, intVariableE, strVariableF]

        let expectedAssociatedDomains: [[any Value]] = [[11, 22, 33], [44, 55, 66], ["xx", "yy", "zz"]]
        let actualAssociatedDomains = TernaryVariable.getAssociatedDomains(from: newAssociatedVariables)

        XCTAssertEqual(actualAssociatedDomains.count, expectedAssociatedDomains.count)
        for idx1 in 0 ..< expectedAssociatedDomains.count {
            XCTAssertEqual(actualAssociatedDomains[idx1].count, expectedAssociatedDomains[idx1].count)
            for idx2 in 0 ..< expectedAssociatedDomains[idx1].count {
                if let expectedValue = expectedAssociatedDomains[idx1][idx2] as? Int,
                   let actualValue = actualAssociatedDomains[idx1][idx2] as? Int {
                    XCTAssertEqual(actualValue, expectedValue)
                    continue
                } else if let expectedValue = expectedAssociatedDomains[idx1][idx2] as? String,
                   let actualValue = actualAssociatedDomains[idx1][idx2] as? String {
                    XCTAssertEqual(actualValue, expectedValue)
                    continue
                }
                XCTFail()
            }
        }
    }

    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(ternaryVariable.domain, expectedTernaryVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        ternaryVariable.assignment = NaryVariableValueType(value: [1, 4, "x"])
        XCTAssertEqual(ternaryVariable.domain, [NaryVariableValueType(value: [1, 4, "x"])])
    }

    func testDomain_setter_validNewDomain_setsDomainCorrectly() {
        let newDomainAsArray: [[any Value]] = [[1, 4, "x"], [2, 5, "y"]]
        let newDomain = Set(newDomainAsArray.map({ NaryVariableValueType(value: $0) }))
        ternaryVariable.domain = newDomain

        XCTAssertEqual(ternaryVariable.domain, newDomain)
    }

    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {

    }

    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(ternaryVariable.assignment)
    }

    func testAssignment_setter_validNewAssignment() {
        for domainValue in expectedTernaryVariableDomain {
            ternaryVariable.unassign()
            ternaryVariable.assignment = domainValue
            XCTAssertEqual(ternaryVariable.assignment, domainValue)
        }
    }

    func testAssignment_setter_currentAssignmentNotNil_throwsError() {

    }

    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {

    }

    func testCanAssign_possibleValue_returnsTrue() {
        for domainValue in expectedTernaryVariableDomain {
            XCTAssertTrue(ternaryVariable.canAssign(to: domainValue))
        }
    }

    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(ternaryVariable.canAssign(to: 4))
        XCTAssertFalse(ternaryVariable.canAssign(to: "success"))
        XCTAssertFalse(ternaryVariable.canAssign(to: true))
        // too many values
        XCTAssertFalse(ternaryVariable.canAssign(to: NaryVariableValueType(value: [1, 4, "x", 10])))
        // first value not in intVariableA's domain
        XCTAssertFalse(ternaryVariable.canAssign(to: NaryVariableValueType(value: [4, 4, "x"])))
    }

    func testAssignTo_possibleValue_getsAssigned() throws {
        for domainValue in expectedTernaryVariableDomain {
            ternaryVariable.unassign()
            ternaryVariable.assign(to: domainValue)
            let assignment = try XCTUnwrap(ternaryVariable.assignment)
            XCTAssertEqual(assignment, domainValue)
        }
    }

    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        // throws error
        ternaryVariable.assign(to: NaryVariableValueType(value: [1, 4, "a"]))
        XCTAssertNil(ternaryVariable.assignment)
        ternaryVariable.assign(to: NaryVariableValueType(value: [1, 5, "y"]))
        // throws error
        ternaryVariable.assign(to: NaryVariableValueType(value: [5, 5, "x"]))
        let actualValue = try XCTUnwrap(ternaryVariable.assignment)
        XCTAssertEqual(actualValue, NaryVariableValueType(value: [1, 5, "y"]))
         */
    }

    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomainAsArray: [[any Value]] = [[1, 4, "x"], [2, 5, "y"]]
        let newDomain = newDomainAsArray.map({ NaryVariableValueType(value: $0) })

        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [NaryVariableValueType]()
        XCTAssertTrue(ternaryVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_setter_notSubsetOfCurrentDomain_returnsFalse() {
        var newDomain: Set<NaryVariableValueType> = expectedTernaryVariableDomain
        let extraDomainValue = NaryVariableValueType(value: [10, 6, "a"])
        newDomain.insert(extraDomainValue)

        XCTAssertFalse(ternaryVariable.canSetDomain(to: Array(newDomain)))
    }

    func testUnassign_assignmentSetToNil() throws {
        let newAssignment = NaryVariableValueType(value: [1, 4, "x"])
        ternaryVariable.assignment = newAssignment
        let actualAssignment = try XCTUnwrap(ternaryVariable.assignment)
        XCTAssertEqual(actualAssignment, newAssignment)
        ternaryVariable.unassign()
        XCTAssertNil(ternaryVariable.assignment)
    }
}
