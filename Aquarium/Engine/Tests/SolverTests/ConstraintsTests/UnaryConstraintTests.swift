//
//  UnaryConstraintTests.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//
@testable import Engine

import XCTest

/*
final class UnaryConstraintTests: XCTestCase {
    var intVariableA: Variable<Int>!
    var intCondition: ((Int) -> Bool)!
    var intConstraint: UnaryConstraint<Int>!
    
    var strVariableA: Variable<String>!
    var strCondition: ((String) -> Bool)!
    var strConstraint: UnaryConstraint<String>!
    
    override func setUp() {
        intVariableA = Variable(name: "A", domain: [1, 2, 3])
        intCondition = { $0 == 2 }
        intConstraint = UnaryConstraint(variable: intVariableA,
                                        condition: intCondition)
        
        strVariableA = Variable(name: "A", domain: ["x", "y", "z"])
        strCondition = { $0 == "z" }
        strConstraint = UnaryConstraint(variable: strVariableA,
                                        condition: strCondition)
    }
    
    func testIsSatisfied_satisfied_returnsTrue() {
        intVariableA.assignment = 2
        XCTAssertTrue(intConstraint.isSatisfied)
        
        strVariableA.assignment = "z"
        XCTAssertTrue(strConstraint.isSatisfied)
    }
    
    func testIsSatisfied_notSatisfied_returnsFalse() {
        intVariableA.assignment = 1
        XCTAssertFalse(intConstraint.isSatisfied)
        
        strVariableA.assignment = "x"
        XCTAssertFalse(strConstraint.isSatisfied)
    }
    
    func testIsSatisfied_unassigned_returnsFalse() {
        XCTAssertFalse(intConstraint.isSatisfied)
        XCTAssertFalse(strConstraint.isSatisfied)
    }
}

*/
