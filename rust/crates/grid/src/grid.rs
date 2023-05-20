use crate::{Action, Cell, Point, PourPoint, Quota};

pub struct Grid {
    pub(crate) qcol: Vec<Quota>,
    pub(crate) qrow: Vec<Quota>,
    pub(crate) cells: Vec<Vec<Cell>>,
    pub(crate) pour_points: Vec<PourPoint>,
    pub(crate) groups: Vec<Vec<usize>>,
}

impl Grid {
    /// Length of the grid along one dimension
    pub fn size(&self) -> usize {
        self.qcol.len()
    }

    pub fn all_points(&self) -> Vec<Point> {
        let mut pts = vec![];
        for r in 0..self.size() {
            for c in 0..self.size() {
                pts.push(Point::new(r, c));
            }
        }
        pts
    }

    /// Get reference to cell at a point
    pub fn cell_at(&self, point: &Point) -> &Cell {
        &self.cells[point.row][point.col]
    }

    /// Get a list of possible water-pouring Actions.
    /// Use when no forcing moves are available.
    pub fn get_next_water_moves(&self) -> Vec<Action> {
        vec![]
    }

    /// Get a list of possible air-pouring Actions.
    /// Use when no forcing moves are available.
    pub fn get_next_air_moves(&self) -> Vec<Action> {
        vec![]
    }

    /// Get a list of all possible Actions. (Water + Air pouring)
    /// Use when no forcing moves are available.
    pub fn get_all_next_moves(&self) -> Vec<Action> {
        let mut moves = self.get_next_water_moves();
        moves.extend(self.get_next_air_moves());
        moves
    }

    pub(crate) fn is_solved(&self) -> bool {
        false
    }
}

impl Grid {
    // Cells that perform uniquely when air/water is poured from them
    // (e.g. if two cells are of the same group on the same row, only
    // one of them should be included in the output)
    pub(crate) fn get_key_points(&self) -> Vec<Point> {
        let mut points: Vec<Point> = vec![];
        for r in 0..self.size() {
            for c in 0..self.size() {
                let g = self.cells[r][c].group;
                if points
                    .iter()
                    .find(|p| p.row == r && self.cell_at(p).group == g)
                    .is_none()
                {
                    points.push(Point::new(r, c));
                }
            }
        }
        points
    }
}
