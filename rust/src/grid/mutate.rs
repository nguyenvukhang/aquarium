use crate::cell::Cell;
use crate::grid::Grid;

impl<'a> Grid<'a> {
    // returns true on change
    pub fn to_water(&mut self, row: usize, col: usize) -> bool {
        if !self.cells[row][col].is_none() {
            return false;
        }
        self.cells[row][col] = Cell::Water;
        self.qrow[row].water -= 1;
        self.qcol[col].water -= 1;
        true
    }

    // returns true on change
    pub fn to_air(&mut self, row: usize, col: usize) -> bool {
        if !self.cells[row][col].is_none() {
            return false;
        }
        self.cells[row][col] = Cell::Air;
        self.qrow[row].air -= 1;
        self.qcol[col].air -= 1;
        true
    }

    // returns true on change
    pub fn to_water_many(&mut self, coords: &Vec<(usize, usize)>) -> bool {
        let mut x = false;
        for (r, c) in coords {
            x |= self.to_water(*r, *c);
        }
        x
    }

    // returns true on change
    pub fn to_air_many(&mut self, coords: &Vec<(usize, usize)>) -> bool {
        let mut x = false;
        for (r, c) in coords {
            x |= self.to_air(*r, *c);
        }
        x
    }

    // returns true on change
    fn _to_water_smart(&mut self, row: usize, col: usize, group: u8) -> bool {
        if self.groups[row][col] != group {
            return false;
        }

        // try to fill current cell
        if !self.to_water(row, col) {
            return false;
        }

        // try downwards
        if row + 1 < self.size() {
            self._to_water_smart(row + 1, col, group);
        }

        // try leftwards
        if col > 0 {
            self._to_water_smart(row, col - 1, group);
        }

        // try rightwards
        if col + 1 < self.size() {
            self._to_water_smart(row, col + 1, group);
        }

        true
    }

    // returns true on change
    fn _to_air_smart(&mut self, row: usize, col: usize, group: u8) -> bool {
        if self.groups[row][col] != group {
            return false;
        }

        // try to fill current cell
        if !self.to_air(row, col) {
            return false;
        }

        // try upwards
        if row > 0 {
            self._to_air_smart(row - 1, col, group);
        }

        // try leftwards
        if col > 0 {
            self._to_air_smart(row, col - 1, group);
        }

        // try rightwards
        if col + 1 < self.size() {
            self._to_air_smart(row, col + 1, group);
        }

        true
    }

    // returns true on change
    pub fn to_water_smart(&mut self, row: usize, col: usize) -> bool {
        self._to_water_smart(row, col, self.groups[row][col])
    }

    // returns true on change
    pub fn to_air_smart(&mut self, row: usize, col: usize) -> bool {
        self._to_air_smart(row, col, self.groups[row][col])
    }

    // turns all cells of a certain group to air ABOVE a specified row
    pub fn group_to_air(&mut self, group: u8, row: usize) -> bool {
        let n = self.size();
        let iter = (0..n).flat_map(|r| (0..n).map(move |c| (r, c)));
        let mut delta = false;

        for (row, col) in iter.filter(|(r, _)| *r <= row) {
            if self.groups[row][col] != group {
                continue;
            }
            delta |= self.to_air(row, col);
        }
        delta
    }

    // turns all cells of a certain group to water BELOW a specified row
    pub fn group_to_water(&mut self, group: u8, row: usize) -> bool {
        let n = self.size();
        let iter = (0..n).flat_map(|r| (0..n).map(move |c| (r, c)));
        let mut delta = false;

        for (row, col) in iter.filter(|(r, _)| *r >= row) {
            if self.groups[row][col] != group {
                continue;
            }
            delta |= self.to_water(row, col);
        }
        delta
    }
}
