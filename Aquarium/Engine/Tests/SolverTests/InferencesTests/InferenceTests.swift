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
    var intVariable: Variable<Int>!
    var intInference: Inference<Int>!
    var strVariableDomain: Set<String>!
    var strVariable: Variable<String>!
    var strInference: Inference<String>!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = Variable(name: "int", domain: intVariableDomain)
        intInference = Inference(variableToDomain: [intVariable: intVariableDomain])
        strVariableDomain = ["a", "b", "c"]
        strVariable = Variable(name: "str", domain: strVariableDomain)
        strInference = Inference(variableToDomain: [strVariable: strVariableDomain])
    }
    
    func testLeadsToFailure() {
        let emptyDomain = Set<Int>()
        let testVariable = Variable(name: "test", domain: emptyDomain)
        var testInference = Inference<Int>()
        testInference.addDomain(for: testVariable, domain: emptyDomain)
        XCTAssertTrue(testInference.leadsToFailure)
    }
    
    func testNumConsistentDomainValues() {
        let expectedValue = 3
        let fromIntInference = intInference.numConsistentDomainValues
        XCTAssertEqual(fromIntInference, expectedValue)
        
        let fromStrInference = strInference.numConsistentDomainValues
        XCTAssertEqual(fromStrInference, expectedValue)
    }
}
