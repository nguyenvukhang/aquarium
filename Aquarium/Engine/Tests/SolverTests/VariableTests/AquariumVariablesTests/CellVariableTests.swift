@testable import Engine
import XCTest

// TODO: test cases ending with "throwsError" should be implemented after errors are implemented!!!
final class CellVariableTests: XCTestCase {
    var cellVariableDomain: Set<CellState>!
    var cellVariable: CellVariable!
    
    override func setUp() {
        cellVariableDomain = Set(CellState.allCases)
        cellVariable = CellVariable(row: 0, col: 0)
    }

    // MARK: Testing methods/attributes defined in CellVariable
    func testCopy_returnsExactCopyButNotSameInstance() {
        let copiedCellVariable = cellVariable.copy()
        XCTAssertEqual(cellVariable, copiedCellVariable)
        XCTAssertFalse(cellVariable === copiedCellVariable)
    }

    // MARK: Testing methods/attributes defined in CellVariable
    func testIsAir_nil_returnsFalse() {
        XCTAssertFalse(cellVariable.isAir)
    }
    
    func testIsAir_water_returnsFalse() {
        cellVariable.assignment = .water
        XCTAssertFalse(cellVariable.isAir)
    }
        
    func testIsAir_air_returnsTrue() {
        cellVariable.assignment = .air
        XCTAssertTrue(cellVariable.isAir)
    }
    
    func testIsWater_nil_returnsFalse() {
        XCTAssertFalse(cellVariable.isWater)
    }
        
    func testIsWater_air_returnsFalse() {
        cellVariable.assignment = .air
        XCTAssertFalse(cellVariable.isWater)
    }
    
    func testIsWater_water_returnsTrue() {
        cellVariable.assignment = .water
        XCTAssertTrue(cellVariable.isWater)
    }
    
    // MARK: Testing methods/attributes inherited from Variable
    func testDomain_getter() {
        XCTAssertEqual(cellVariable.domain, cellVariableDomain)
    }

    func testDomain_getter_variableAssigned_returnsOnlyOneValue() {
        cellVariable.assignment = .water
        XCTAssertEqual(cellVariable.domain, [.water])
    }

    func testDomain_setter_validNewDomain_setsDomainCorrectly() {
        let newDomain = Set([CellState.water])
        cellVariable.domain = newDomain
        
        XCTAssertEqual(cellVariable.domain, newDomain)
    }

    func testDomain_setter_notSubsetOfCurrentDomain_throwsError() {
        
    }
    
    func testAssignment_getter_initialAssignmentNil() {
        XCTAssertNil(cellVariable.assignment)
    }
    
    func testAssignment_setter_validNewAssignment() {
        cellVariable.assignment = .water
        XCTAssertEqual(cellVariable.assignment, .water)
        
        cellVariable.unassign()
        cellVariable.assignment = .air
        XCTAssertEqual(cellVariable.assignment, .air)
    }
    
    func testAssignment_setter_currentAssignmentNotNil_throwsError() {
        
    }
    
    func testAssignment_setter_newAssignmentNotInDomain_throwsError() {
        
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
        
        cellVariable.unassign()
        cellVariable.assign(to: CellState.air)
        let cellValueAir = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValueAir, .air)
    }
    
    func testAssignTo_impossibleValue_throwsError() throws {
        /*
        // restricting domain only to true, so setting to false should fail
        cellVariable.domain = Set([CellState.water])
        
        cellVariable.assign(to: CellState.air)
        XCTAssertNil(cellVariable.assignment)
        
        cellVariable.assign(to: CellState.water)
        cellVariable.assign(to: CellState.air)
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, CellState.water)
         */
    }
    
    func testCanSetDomain_validNewDomain_returnsTrue() {
        let newDomain = [CellState.water]
        XCTAssertTrue(cellVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_emptyDomain_returnsTrue() {
        let newDomain = [CellState]()
        XCTAssertTrue(cellVariable.canSetDomain(to: newDomain))
    }

    func testCanSetDomain_setter_notSubsetOfCurrentDomain_returnsFalse() {
        let newDomain: [any Value] = [CellState.water, CellState.air, 1]
        XCTAssertFalse(cellVariable.canSetDomain(to: newDomain))
    }
    
    func testUnassign_assignmentSetToNil() throws {
        cellVariable.assignment = CellState.air
        let cellValue = try XCTUnwrap(cellVariable.assignment)
        XCTAssertEqual(cellValue, .air)
        cellVariable.unassign()
        XCTAssertNil(cellVariable.assignment)
    }
}
