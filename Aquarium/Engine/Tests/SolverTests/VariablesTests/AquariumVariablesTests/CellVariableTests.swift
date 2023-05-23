@testable import Engine

import XCTest

final class CellVariableTests: XCTestCase {
    var cellVariable: CellVariable!
    
    override func setUp() {
        cellVariable = CellVariable(row: 0, col: 0)
    }
    
    func testCanAssign_possibleValue_returnsTrue() {
        XCTAssertTrue(cellVariable.canAssign(to: CellState.water))
        XCTAssertTrue(cellVariable.canAssign(to: CellState.air))
    }
    
    func testCanAssign_impossibleValue_returnsFalse() {
        XCTAssertFalse(cellVariable.canAssign(to: 1))
        XCTAssertFalse(cellVariable.canAssign(to: "fail"))
        XCTAssertFalse(cellVariable.canAssign(to: true))
    }
    
    func testAssignTo_possibleValue_getsAssigned() throws {
        cellVariable.assign(to: CellState.water)
        let cellValueWater = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValueWater, .water)
        
        cellVariable.assign(to: CellState.air)
        let cellValueAir = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValueAir, .air)
    }
    
    func testAssignTo_impossibleValue_notAssigned() throws {
        // restricting domain only to true, so setting to false should fail
        cellVariable.domain = Set([CellState.water])
        
        cellVariable.assign(to: CellState.air)
        XCTAssertNil(cellVariable.assignment)
        
        cellVariable.assign(to: CellState.water)
        cellVariable.assign(to: CellState.air)
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, CellState.water)
    }
    
    func testSetDomain_validDomain() {
        let newValidDomain = [CellState.water]
        cellVariable.setDomain(newDomain: newValidDomain)
        XCTAssertEqual(cellVariable.domain, Set(newValidDomain))
    }
    
    // TODO: put back after introducing error messages
    /*
    func testSetDomain_invalidDomain_throwsError() {
        let invalidDomain = ["a", "b", "c"]
        XCTAssertThrowsError(cellVariable.setDomain(newDomain: invalidDomain))
        XCTAssertEqual(cellVariable.domain, Set(CellState.allCases))
    }
     */
    
    func testUnassign_assignmentSetToNil() throws {
        cellVariable.assign(to: CellState.air)
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, .air)
        cellVariable.unassign()
        XCTAssertNil(cellVariable.assignment)
    }
}
