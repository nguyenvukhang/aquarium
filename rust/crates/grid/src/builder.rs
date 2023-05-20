use crate::{Cell, Point, PourPoint};

// Cells that perform uniquely when air/water is poured from them
// (e.g. if two cells are of the same group on the same row, only
// one of them should be included in the output)
pub fn get_key_points(cells: &Vec<Vec<Cell>>) -> Vec<PourPoint> {
    let size = cells.len();
    let mut points: Vec<Point> = vec![];
    for r in 0..size {
        for c in 0..size {
            let g = cells[r][c].group;
            if points
                .iter()
                .find(|p| p.row == r && cells[p.row][p.col].group == g)
                .is_none()
            {
                points.push(Point::new(r, c));
            }
        }
    }
    points.into_iter().map(|v| PourPoint::new(v, &cells)).collect()
}
