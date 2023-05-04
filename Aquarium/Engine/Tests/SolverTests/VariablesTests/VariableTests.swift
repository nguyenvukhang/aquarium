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
    var intVariable: Variable<Int>!
    var strVariableDomain: Set<String>!
    var strVariable: Variable<String>!
    
    override func setUp() {
        intVariableDomain = [1, 2, 3]
        intVariable = Variable(name: "int", domain: intVariableDomain)
        strVariableDomain = ["a", "b", "c"]
        strVariable = Variable(name: "str", domain: strVariableDomain)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        for intValue in intVariableDomain {
            XCTAssertTrue(intVariable.canAssign(to: intValue))
        }
        for strValue in strVariableDomain {
            XCTAssertTrue(strVariable.canAssign(to: strValue))
        }
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(intVariable.canAssign(to: 4))
        XCTAssertFalse(intVariable.canAssign(to: 5))
        XCTAssertFalse(strVariable.canAssign(to: "d"))
        XCTAssertFalse(strVariable.canAssign(to: "e"))
    }
    
    func testAssignment_possibleValue_getsAssigned() throws {
        for intValue in intVariableDomain {
            intVariable.assignment = intValue
            let intValue = try XCTUnwrap(intVariable.assignment)
            XCTAssertEqual(intValue, intValue)
        }
        for strValue in strVariableDomain {
            strVariable.assignment = strValue
            let strValue = try XCTUnwrap(strVariable.assignment)
            XCTAssertEqual(strValue, strValue)
        }
    }
    
    func testAssignment_impossibleValue_notAssigned() throws {
        intVariable.assignment = 4
        XCTAssertNil(intVariable.assignment)
        intVariable.assignment = 3
        intVariable.assignment = 5
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 3)
        
        strVariable.assignment = "d"
        XCTAssertNil(strVariable.assignment)
        strVariable.assignment = "c"
        strVariable.assignment = "e"
        let strValue = try XCTUnwrap(strVariable.assignment)
        XCTAssertEqual(strValue, "c")
    }
    
    func testUnassign_assignmentSetToNil() throws {
        intVariable.assignment = 2
        let intValue = try XCTUnwrap(intVariable.assignment)
        XCTAssertEqual(intValue, 2)
        intVariable.unassign()
        XCTAssertNil(intVariable.assignment)
        
        strVariable.assignment = "b"
        let strValue = try XCTUnwrap(strVariable.assignment)
        XCTAssertEqual(strValue, "b")
        strVariable.unassign()
        XCTAssertNil(strVariable.assignment)
    }
    
    func testPruneRemainingDomain() {
        let intConditionToKeep = { intVal in intVal > 2 }
        intVariable.pruneRemainingDomain(toSatisfy: intConditionToKeep)
        XCTAssertEqual(intVariable.remainingDomain, [3])
        
        let strConditionToKeep = { strVal in Set(["b", "c", "d"]).contains(strVal) }
        strVariable.pruneRemainingDomain(toSatisfy: strConditionToKeep)
        XCTAssertEqual(strVariable.remainingDomain, ["b", "c"])
    }
}
