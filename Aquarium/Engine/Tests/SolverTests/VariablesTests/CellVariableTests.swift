//
//  CellVariableTests.swift
//  
//
//  Created by Quan Teng Foong on 20/5/23.
//
@testable import Engine

import XCTest

final class CellVariableTests: XCTestCase {
    var cellVariable: CellVariable!
    
    override func setUp() {
        cellVariable = CellVariable(row: 0, col: 0)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        XCTAssertTrue(cellVariable.canAssign(to: true))
        XCTAssertTrue(cellVariable.canAssign(to: false))
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(cellVariable.canAssign(to: 1))
        XCTAssertFalse(cellVariable.canAssign(to: "fail"))
    }
    
    func testAssignTo_possibleValue_getsAssigned() throws {
        cellVariable.assign(to: true)
        let cellValueTrue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValueTrue, true)
        
        cellVariable.assign(to: false)
        let cellValueFalse = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValueFalse, false)
    }
    
    func testAssignTo_impossibleValue_notAssigned() throws {
        // restricting domain only to true, so setting to false should fail
        cellVariable.domain = Set([true])
        
        cellVariable.assign(to: false)
        XCTAssertNil(cellVariable.assignment)
        
        cellVariable.assign(to: true)
        cellVariable.assign(to: false)
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, true)
    }
    
    func testSetDomain_validDomain() {
        let newValidDomain = [true]
        cellVariable.setDomain(newDomain: newValidDomain)
        XCTAssertEqual(cellVariable.domain, Set(newValidDomain))
    }
    
    // TODO: put back after introducing error messages
    /*
    func testSetDomain_invalidDomain_throwsError() {
        let invalidDomain = ["a", "b", "c"]
        XCTAssertThrowsError(cellVariable.setDomain(newDomain: invalidDomain))
        XCTAssertEqual(cellVariable.domain, Set([true, false]))
    }
     */
    
    func testUnassign_assignmentSetToNil() throws {
        cellVariable.assign(to: false)
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, false)
        cellVariable.unassign()
        XCTAssertNil(cellVariable.assignment)
    }
}
