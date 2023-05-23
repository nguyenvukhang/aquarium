@testable import Engine
import XCTest

final class NaryVariableTests: XCTestCase {
    var naryVariable: NaryVariable!
    var intVariableA: IntVariable!
    var intVariableB: IntVariable!
    var intVariableC: IntVariable!

    override func setUp() {
        intVariableA = IntVariable(name: "intA", domain: Set([1, 2, 3]))
        intVariableB = IntVariable(name: "intB", domain: Set([4, 5, 6]))
        intVariableC = IntVariable(name: "intC", domain: Set([7, 8, 9]))
        naryVariable = NaryVariable(name: "nary", associatedVariables: [intVariableA,
                                                                        intVariableB,
                                                                        intVariableC])
    }

    func testDomain_getter() {
        let associatedVariableDomains = [intVariableA.domainAsArray,
                                         intVariableB.domainAsArray,
                                         intVariableC.domainAsArray]
        let possibleAssignments = Array<any Value>.possibleAssignments(domains: associatedVariableDomains)
        let expectedDomain = Set(possibleAssignments.map({ NaryVariableDomainValue(value: $0) }))
        
        let actualDomain: Set<NaryVariableDomainValue> = naryVariable.domain
        
        XCTAssertEqual(actualDomain, expectedDomain)
    }
    
    func testDomain_setter() {
        XCTAssertEqual(Set(naryVariable.associatedDomains[0] as! [Int]), Set(intVariableA.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[1] as! [Int]), Set(intVariableB.domainAsArray))
        XCTAssertEqual(Set(naryVariable.associatedDomains[2] as! [Int]), Set(intVariableC.domainAsArray))
        
        let domainsToSet = [[1, 4, 7],
                            [2, 4, 7]]
        let domainsToSetAsNaryVariableDomainValues = domainsToSet.map({ NaryVariableDomainValue(value: $0) })
        let newNaryVariableDomain = Set<NaryVariableDomainValue>(domainsToSetAsNaryVariableDomainValues)
        naryVariable.domain = newNaryVariableDomain
        
        XCTAssertEqual(Set(naryVariable.associatedDomains[0] as! [Int]), Set([1, 2]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[1] as! [Int]), Set([4]))
        XCTAssertEqual(Set(naryVariable.associatedDomains[2] as! [Int]), Set([7]))
    }
    
    func testAssignment_getter() {
        intVariableA.assign(to: 2)
        intVariableB.assign(to: 4)
        intVariableC.assign(to: 7)
        let expectedAssignment = NaryVariableDomainValue(value: [2, 4, 7])
        let actualAssignment = naryVariable.assignment
        
        XCTAssertEqual(actualAssignment, expectedAssignment)
    }
    
    func testAssignment_setter() {
        let assignmentToSet = NaryVariableDomainValue(value: [3, 5, 9])
        naryVariable.assignment = assignmentToSet
        
        XCTAssertEqual(intVariableA.assignment, 3)
        XCTAssertEqual(intVariableB.assignment, 5)
        XCTAssertEqual(intVariableC.assignment, 9)
    }
    
    func testAssociatedDomains() {
        let expectedAssociatedDomains = [Set([1, 2, 3]),
                                         Set([4, 5, 6]),
                                         Set([7, 8, 9])]
        let actualAssociatedDomains = naryVariable.associatedDomains.map({ Set($0 as! [Int]) })
        XCTAssertEqual(actualAssociatedDomains, expectedAssociatedDomains)
    }
}
