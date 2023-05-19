//
//  VariableTests.swift
//  
//
//  Created by Quan Teng Foong on 4/5/23.
//
@testable import Engine

import XCTest

final class VariableTests: XCTestCase {
    var intVariableDomain: Set<Int>!
    var intVariable: IntVariable!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = IntVariable(name: "int", domain: intVariableDomain)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        for intValue in intVariableDomain {
            XCTAssertTrue(intVariable.canAssign(to: intValue))
        }
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(intVariable.canAssign(to: 4))
        XCTAssertFalse(intVariable.canAssign(to: 5))
    }
    
    func testAssignment_possibleValue_getsAssigned() throws {
        for intValue in intVariableDomain {
            intVariable.assignment = intValue
            let intValue = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(intValue, intValue)
        }
    }
    
    func testAssignment_impossibleValue_notAssigned() throws {
        intVariable.assignment = 4
        XCTAssertNil(intVariable.assignment)
        intVariable.assignment = 3
        intVariable.assignment = 5
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 3)
    }
    
    func testUnassign_assignmentSetToNil() throws {
        intVariable.assignment = 2
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
    }
}
