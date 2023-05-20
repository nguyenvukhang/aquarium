import Foundation

struct PourPoint {
    let point: Point
    let waterFlow: [Point]
    let airFlow: [Point]

    init(point: Point, groups: [[Int]]) {
        self.point = point

        var waterFlow = [Point]()
        var airFlow = [Point]()

        let group = groups[point]

        let size = groups.count

        for row in 0..<size {
            for col in 0..<size {
                if groups[row][col] != group {
                    continue
                }
                if row >= point.row {
                    waterFlow.append(Point(row, col))
                }
                if row <= point.row {
                    airFlow.append(Point(row, col))
                }
            }
        }
        self.waterFlow = waterFlow
        self.airFlow = airFlow
    }

    func getPoints(_ state: State) -> [Point] {
        switch state {
        case .water: return waterFlow
        case .air: return airFlow
        case .none: return []
        }
    }
}

extension PourPoint: CustomDebugStringConvertible {
    var debugDescription: String {
        "PourPoint\(point) { water: \(waterFlow)}, air: \(airFlow)"
    }
}
