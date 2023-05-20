use crate::{Cell, Point};

#[derive(Debug)]
pub struct PourPoint {
    pub point: Point,
    pub water_flow: Vec<Point>,
    pub air_flow: Vec<Point>,
}

impl PourPoint {
    pub fn new(point: Point, cells: &Vec<Vec<Cell>>) -> Self {
        let size = cells.len();
        let group = cells[point.row][point.col].group;
        let (mut water_flow, mut air_flow) = (vec![], vec![]);

        for r in 0..size {
            for c in 0..size {
                if cells[r][c].group != group {
                    continue;
                }
                if r >= point.row {
                    water_flow.push(Point::new(r, c));
                }
                if r <= point.row {
                    air_flow.push(Point::new(r, c));
                }
            }
        }

        Self { point, water_flow, air_flow }
    }
}
