//
//  BinaryConstraintTests.swift
//  
//
//  Created by Quan Teng Foong on 3/5/23.
//
@testable import Engine

import XCTest

/*
final class BinaryConstraintTests: XCTestCase {
    var intVariableA: Variable<Int>!
    var intVariableB: Variable<Int>!
    var intCondition: ((Int, Int) -> Bool)!
    var intConstraint: BinaryConstraint<Int>!
    
    var strVariableA: Variable<String>!
    var strVariableB: Variable<String>!
    var strCondition: ((String, String) -> Bool)!
    var strConstraint: BinaryConstraint<String>!
    
    override func setUp() {
        intVariableA = Variable(name: "A", domain: [1, 2, 3])
        intVariableB = Variable(name: "B", domain: [1, 2, 3])
        intCondition = { $0 + $1 == 5 }
        intConstraint = BinaryConstraint(variable1: intVariableA,
                                         variable2: intVariableB,
                                         condition: intCondition)
        
        strVariableA = Variable(name: "A", domain: ["x", "y", "z"])
        strVariableB = Variable(name: "B", domain: ["p", "q", "r"])
        strCondition = { $0 + $1 == "zr" }
        strConstraint = BinaryConstraint(variable1: strVariableA,
                                         variable2: strVariableB,
                                         condition: strCondition)
    }
    
    func testIsSatisfied_satisfied_returnsTrue() {
        intVariableA.assignment = 2
        intVariableB.assignment = 3
        XCTAssertTrue(intConstraint.isSatisfied)
        intVariableA.assignment = 3
        intVariableB.assignment = 2
        XCTAssertTrue(intConstraint.isSatisfied)
        
        strVariableA.assignment = "z"
        strVariableB.assignment = "r"
        XCTAssertTrue(strConstraint.isSatisfied)
    }
    
    func testIsSatisfied_notSatisfied_returnsFalse() {
        intVariableA.assignment = 1
        intVariableB.assignment = 3
        XCTAssertFalse(intConstraint.isSatisfied)
        
        strVariableA.assignment = "x"
        strVariableB.assignment = "r"
        XCTAssertFalse(strConstraint.isSatisfied)
    }
    
    func testIsSatisfied_unassigned_returnsFalse() {
        XCTAssertFalse(intConstraint.isSatisfied)
        intVariableA.assignment = 3
        intVariableB.unassign()
        XCTAssertFalse(intConstraint.isSatisfied)
        intVariableA.unassign()
        intVariableB.assignment = 2
        XCTAssertFalse(intConstraint.isSatisfied)
        
        XCTAssertFalse(strConstraint.isSatisfied)
        strVariableA.assignment = "x"
        strVariableB.unassign()
        XCTAssertFalse(strConstraint.isSatisfied)
        strVariableA.unassign()
        strVariableB.assignment = "r"
        XCTAssertFalse(strConstraint.isSatisfied)
    }
}

*/
