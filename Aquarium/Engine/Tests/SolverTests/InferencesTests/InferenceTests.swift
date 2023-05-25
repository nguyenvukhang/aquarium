@testable import Engine

import XCTest

final class InferenceTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!
    
    var stringVariableDomain: Set<String>!
    var stringVariable: StringVariable!
    
    var inference: Inference!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
        
        stringVariableDomain = ["a", "b", "c"]
        stringVariable = StringVariable(name: "string", domain: stringVariableDomain)
        
        inference = Inference()
        inference.addDomain(for: intVariable, domain: Array(intVariableDomain))
        inference.addDomain(for: stringVariable, domain: Array(stringVariableDomain))
    }
    
    func testLeadsToFailure_allVariablesHaveNonEmptyDomains_returnsFalse() {
        XCTAssertFalse(inference.leadsToFailure)
    }
    
    func testLeadsToFailure_includesVariableWithEmptyDomain_returnsTrue() {
        let emptyDomain = Set<Int>()
        let testIntVariable = IntVariable(name: "test", domain: emptyDomain)
        inference.addDomain(for: testIntVariable, domain: Array(emptyDomain))
        XCTAssertTrue(inference.leadsToFailure)
    }
    
    func testNumConsistentDomainValues() {
        var expectedValue = intVariable.domainSize + stringVariable.domainSize
        var actualValue = inference.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)
        
        // reduce intVariable domain size
        let newIntVariableDomain = Set([1, 2])
        inference.addDomain(for: intVariable, domain: Array(newIntVariableDomain))
        expectedValue -= 1
        actualValue = inference.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)
        
        // reduce stringVariable domain size
        let newStringVariableDomain = Set(["c", "a"])
        inference.addDomain(for: stringVariable, domain: Array(newStringVariableDomain))
        expectedValue -= 1
        actualValue = inference.numConsistentDomainValues
        XCTAssertEqual(actualValue, expectedValue)
    }

    func testAddDomainAndGetDomain_overwritesPreviousValue() throws {
        let newDomain = Set([1, 2])
        inference.addDomain(for: intVariable, domain: Array(newDomain))
        let newInferredDomainAsArray = try XCTUnwrap(inference.getDomain(for: intVariable))
        let newInferredDomainAsSet = intVariable.createValueTypeSet(from: newInferredDomainAsArray)
        XCTAssertEqual(newInferredDomainAsSet, newDomain)
    }

    func testAddDomain_invalidDomain_throwsError() {
        // TODO: implement after errors are implemented
    }

    func testGetDomain_getsValueCorrectly() throws {
        let inferredDomainAsArray = try XCTUnwrap(inference.getDomain(for: intVariable))
        let inferredDomainAsSet = intVariable.createValueTypeSet(from: inferredDomainAsArray)
        XCTAssertEqual(inferredDomainAsSet, intVariableDomain)
    }
}
