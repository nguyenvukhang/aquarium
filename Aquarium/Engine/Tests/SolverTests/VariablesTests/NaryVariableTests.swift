@testable import Engine
import XCTest

/*
final class NaryVariableTests: XCTestCase {
    var intVariableA: IntVariable!
    var strVariableB: StringVariable!
    var intVariableC: IntVariable!
    var strVariableD: StringVariable!
    var intVariableE: IntVariable!
    var strVariableF: StringVariable!
    
    var allAssociatedVariables: [any Variable]!
    
    var naryVariable: NaryVariable!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        strVariableB = StringVariable(name: "strB", domain: Set(["a", "b", "c"]))
        intVariableC = IntVariable(name: "intC", domain: Set([4, 5, 6]))
        strVariableD = StringVariable(name: "strD", domain: Set(["d", "e", "f"]))
        intVariableE = IntVariable(name: "intE", domain: Set([7, 8, 9]))
        strVariableF = StringVariable(name: "strF", domain: Set(["g", "h", "i"]))
        
        allAssociatedVariables = [intVariableA,
                                  strVariableB,
                                  intVariableC,
                                  strVariableD,
                                  intVariableE,
                                  strVariableF]
        
        naryVariable = NaryVariable(name: "nary", associatedVariables: allAssociatedVariables)
    }

    func testDomain_getter_allVariableDomainNonEmpty_returnsAllPossibleAssignments() {
        let associatedVariableDomains = allAssociatedVariables.map({ $0.domainAsArray })
        let possibleAssignments = Array<any Value>.possibleAssignments(domains: associatedVariableDomains)
        let expectedDomain = Set(possibleAssignments.map({ NaryVariableDomainValue(value: $0) }))
        
        let actualDomain = naryVariable.domain
        
        XCTAssertEqual(actualDomain, expectedDomain)
    }
    
    func testDomain_getter_someVariableDomainEmpty_returnsEmptySet() {
        strVariableD.setDomain(newDomain: [])
        
        let actualDomain = naryVariable.domain
        
        XCTAssertNil(actualDomain)
    }
    
    func testDomain_setter() {
        XCTAssertEqual(Set(naryVariable.associatedDomains[0] as! [Int]), Set(intVariableA.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[1] as! [String]), Set(strVariableB.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[2] as! [Int]), Set(intVariableC.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[3] as! [String]), Set(strVariableD.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[4] as! [Int]), Set(intVariableE.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[5] as! [String]), Set(strVariableF.domainAsArray))
        
        let domainsToSet: [[any Value]] = [[1, "b", 4, "d", 7, "i"],
                                           [2, "c", 4, "f", 7, "i"]]
        let domainsToSetAsNaryVariableDomainValues = domainsToSet.map({ NaryVariableDomainValue(value: $0) })
        let newNaryVariableDomain = Set<NaryVariableDomainValue>(domainsToSetAsNaryVariableDomainValues)
        naryVariable.domain = newNaryVariableDomain
        
        XCTAssertEqual(Set(naryVariable.associatedDomains[0] as! [Int]), Set([1, 2]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[1] as! [String]), Set(["b", "c"]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[2] as! [Int]), Set([4]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[3] as! [String]), Set(["d", "f"]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[4] as! [Int]), Set([7]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[5] as! [String]), Set(["i"]))
    }
    
    // TODO: fill in when errors implemented
    /*
    func testDomain_setter_newDomainNotInVariableDomain_throwsError() {
        let domainsToSet: [[any Value]] = [[10, "b", 4, "d", 7, "i"]]
    }
    
    func testDomain_setter_newDomainContainsWrongType_throwsError() {
        let domainToSet: [[any Value]] = [[1, 2, 3, 4, 5, 6]]
    }
    
    func testDomain_setter_newDomainIncorrectLength_throwsError() {
        // test length longer than 6
        // test length shorter than 6
    }
     */
    
    func testAssignment_getter_allVariablesAssigned_returnsCorrectAssignment() {
        intVariableA.assign(to: 2)
        strVariableB.assign(to: "b")
        intVariableC.assign(to: 4)
        strVariableD.assign(to: "f")
        intVariableE.assign(to: 7)
        strVariableF.assign(to: "g")
        
        let expectedAssignment = NaryVariableDomainValue(value: [2, "b", 4, "f", 7, "g"])
        let actualAssignment = naryVariable.assignment
        
        XCTAssertEqual(actualAssignment, expectedAssignment)
    }
    
    func testAssignment_getter_someVariableUnassigned_returnsNil() {
        intVariableA.assign(to: 2)
        
        intVariableC.assign(to: 4)
        strVariableD.assign(to: "f")
        intVariableE.assign(to: 7)
        strVariableF.assign(to: "g")
        
        let actualAssignment = naryVariable.assignment
        
        XCTAssertNil(actualAssignment)
    }
    
    func testAssignment_setter() {
        let assignmentToSet = NaryVariableDomainValue(value: [3, 5, 9, 1, 3, 4])
        naryVariable.assignment = assignmentToSet
        
        XCTAssertEqual(intVariableA.assignment, 3)
        XCTAssertEqual(intVariableC.assignment, 5)
        XCTAssertEqual(intVariableC.assignment, 9)
    }
    
    // TODO: fill in when errors implemented
    /*
    func testAssignment_setter_newAssignmentNotVariableDomain_throwsError() {
        let assignmentToSet = NaryVariableDomainValue(value: [1, "x", 4, "f", 7, "g"]
    }
     
    func testAssignment_setter_newAssignmentContainsWrongType_throwsError() {
        let assignmentToSet = NaryVariableDomainValue(value: [1, 2, 3, 4, 5, 6]
    }
    
    func testAssignment_setter_newAssignmentIncorrectLength_throwsError() {
        // test length longer than 6
        // test length shorter than 6
    }
     */
    
    func testAssociatedDomains() {
        let expectedAssociatedDomains = [Set([1, 2, 3]),
                                         Set([4, 5, 6]),
                                         Set([7, 8, 9])]
        let actualAssociatedDomains = naryVariable.associatedDomains.map({ Set($0 as! [Int]) })
        XCTAssertEqual(actualAssociatedDomains, expectedAssociatedDomains)
    }
}
*/
