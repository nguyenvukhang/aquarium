//
//  InferencesTests.swift
//  
//
//  Created by Quan Teng Foong on 9/5/23.
//
@testable import Engine

import XCTest

final class InferenceTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!
    var inference: Inference!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
        inference = Inference()
        inference.addDomain(for: intVariable, domain: Array(intVariableDomain))
    }
    
    func testLeadsToFailure() {
        let emptyDomain = Set<Int>()
        let testIntVariable = IntVariable(name: "test", domain: emptyDomain)
        var testInference = Inference()
        testInference.addDomain(for: testIntVariable, domain: Array(emptyDomain))
        XCTAssertTrue(testInference.leadsToFailure)
    }
    
    func testNumConsistentDomainValues() {
        let expectedValue = 3
        let fromInference = inference.numConsistentDomainValues
        XCTAssertEqual(fromInference, expectedValue)
    }
}
