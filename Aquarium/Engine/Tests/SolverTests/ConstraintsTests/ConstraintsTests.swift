//
//  ConstraintsTests.swift
//  
//
//  Created by Quan Teng Foong on 4/5/23.
//
@testable import Engine

import XCTest

final class ConstraintsTests: XCTestCase {
    var intVariableA: Variable<Int>!
    var intVariableB: Variable<Int>!
    
    var intUnaryCondition: ((Int) -> Bool)!
    var intBinaryCondition: ((Int, Int) -> Bool)!
    
    var intUnaryConstraint: UnaryConstraint<Int>!
    var intBinaryConstraint: BinaryConstraint<Int>!
    
    var constraints: Constraints!
    
    override func setUp() {
        intVariableA = Variable(name: "A", domain: [1, 2, 3])
        intVariableB = Variable(name: "B", domain: [1, 2, 3])
        
        intUnaryCondition = { $0 == 2 }
        intBinaryCondition = { $0 + $1 == 5 }
        
        intUnaryConstraint = UnaryConstraint(variable: intVariableA,
                                             condition: intUnaryCondition)
        intBinaryConstraint = BinaryConstraint(variable1: intVariableA,
                                               variable2: intVariableB,
                                               condition: intBinaryCondition)
        
        constraints = Constraints(allConstraints: [intUnaryConstraint, intBinaryConstraint])
    }
    
    func testAllSatisfied_onlyUnaryConstraintSatisfied_returnsFalse() {
        intVariableA.assignment = 2
        XCTAssertFalse(constraints.allSatisfied)
    }
    
    func testAllSatisfied_onlyBinaryConstraintSatisfied_returnsFalse() {
        intVariableA.assignment = 3
        intVariableB.assignment = 2
        XCTAssertFalse(constraints.allSatisfied)
    }
    
    func testAllSatisfied_bothConstraintsSatisfied_returnsTrue() {
        intVariableA.assignment = 2
        intVariableB.assignment = 3
        XCTAssertTrue(constraints.allSatisfied)
    }
}
