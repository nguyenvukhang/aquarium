@testable import Engine
import XCTest

final class FlowToOthersConstraintTests: XCTestCase {
    var mainCell: CellVariable!
    var adjacentCells: [CellVariable]!
    var flowToOthersConstraint: FlowToOthersConstraint!
    
    override func setUp() {
        mainCell = CellVariable(row: 0, col: 1)
        adjacentCells = [CellVariable(row: 0, col: 0),
                         CellVariable(row: 0, col: 2),
                         CellVariable(row: 1, col: 1)]
        flowToOthersConstraint = FlowToOthersConstraint(mainCell: mainCell, adjacentCells: adjacentCells)
    }
    
    func testVariables_returnsAllCells() {
        let expectedVariables = adjacentCells + [mainCell]
        let actualVariables = flowToOthersConstraint.variables
        XCTAssertEqual(actualVariables.count, expectedVariables.count)
        for expectedVariable in expectedVariables {
            XCTAssertTrue(actualVariables.contains(where: { $0 === expectedVariable}))
        }
    }
    
    // MARK: tests for isSatisfied
    func testIsSatisfied_mainCellUnassigned_returnsFalse() {
        for cell in adjacentCells {
            cell.assign(to: CellState.water)
        }
        XCTAssertFalse(flowToOthersConstraint.isSatisfied)
    }
    
    func testIsSatisfied_mainCellAir_adjacentCellsAllAssigned_returnsTrue() {
        mainCell.assign(to: CellState.air)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        adjacentCells[2].assign(to: CellState.air)
        
        XCTAssertTrue(flowToOthersConstraint.isSatisfied)
    }
    
    func testIsSatisfied_mainCellAir_adjacentCellsPartiallyAssigned_returnsFalse() {
        mainCell.assign(to: CellState.air)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        
        XCTAssertFalse(flowToOthersConstraint.isSatisfied)
    }
    
    func testIsSatisfied_mainCellWater_adjacentCellsPartiallyAssigned_returnsFalse() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        
        XCTAssertFalse(flowToOthersConstraint.isSatisfied)
    }
    
    func testIsSatisfied_mainCellWater_adjacentCellsContainsAir_returnsFalse() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        adjacentCells[2].assign(to: CellState.water)
        
        XCTAssertFalse(flowToOthersConstraint.isSatisfied)
    }
    
    func testIsSatisfied_mainCellWater_adjacentCellsAllWater_returnsTrue() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.water)
        adjacentCells[1].assign(to: CellState.water)
        adjacentCells[2].assign(to: CellState.water)
        
        XCTAssertTrue(flowToOthersConstraint.isSatisfied)
    }
    
    // MARK: tests for isViolated
    func testIsViolated_mainCellWater_adjacentCellsContainsAir_returnsTrue() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        adjacentCells[2].assign(to: CellState.water)
        
        XCTAssertTrue(flowToOthersConstraint.isViolated)
    }
    
    func testIsViolated_mainCellWater_adjacentCellsPartiallyAssignedContainsAir_returnsTrue() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        
        XCTAssertTrue(flowToOthersConstraint.isViolated)
    }
    
    func testIsViolated_mainCellWater_adjacentCellsDoesNotContainAir_returnsFalse() {
        mainCell.assign(to: CellState.water)
        adjacentCells[0].assign(to: CellState.water)
        adjacentCells[2].assign(to: CellState.water)
        
        XCTAssertFalse(flowToOthersConstraint.isViolated)
    }
    
    func testIsViolated_mainCellAir_adjacentCellsUnassigned_returnsFalse() {
        mainCell.assign(to: CellState.air)
        
        XCTAssertFalse(flowToOthersConstraint.isViolated)
    }
    
    func testIsViolated_mainCellAir_adjacentCellsPartiallyAssigned_returnsFalse() {
        mainCell.assign(to: CellState.air)
        adjacentCells[0].assign(to: CellState.air)
        adjacentCells[1].assign(to: CellState.water)
        
        XCTAssertFalse(flowToOthersConstraint.isViolated)
    }
}
