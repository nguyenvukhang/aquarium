mod debug;

use crate::quota::Quota;

use crate::cell::Cell;
#[derive(Clone, PartialEq, Eq)]
pub struct Grid<'a> {
    size: usize,
    pub cells: Vec<Vec<Cell>>,
    col_quota: Vec<Quota>,
    row_quota: Vec<Quota>,
    groups: &'a Vec<Vec<u8>>,
    group_count: usize,
    dirty: bool,
}

impl<'a> Grid<'a> {
    pub fn new(
        groups: &'a Vec<Vec<u8>>,
        cols: &Vec<i32>,
        rows: &Vec<i32>,
    ) -> Self {
        // can store 5 cells in each u8
        let size = groups.len();
        let cells = vec![vec![Cell::None; size]; size];
        let col_quota = cols.iter().map(|v| Quota::new(*v, size)).collect();
        let row_quota = rows.iter().map(|v| Quota::new(*v, size)).collect();
        let group_count =
            *groups.iter().flat_map(|v| v.iter().max()).max().unwrap_or(&0)
                as usize;
        let dirty = false;
        Self { size, cells, groups, col_quota, row_quota, group_count, dirty }
    }

    fn iter(&self) -> impl Iterator<Item = (usize, usize)> {
        let n = self.size;
        (0..n).flat_map(move |r| (0..n).map(move |c| (r, c)))
    }

    /// Pour water starting from (row, col) and update sums
    pub fn pour_water(&mut self, row: usize, col: usize) {
        let g = self.groups[row][col];
        let iter = self.iter().filter(|(r, _)| *r >= row);
        for (r, c) in iter {
            if self.groups[r][c] == g {
                self.col_quota[c].water -= 1;
                self.row_quota[r].water -= 1;
                self.cells[r][c] = Cell::Water;
                self.dirty = true;
            }
        }
    }

    /// Pour air starting from (row, col) and update sums
    pub fn pour_air(&mut self, row: usize, col: usize) {
        let g = self.groups[row][col];
        let iter = self.iter().filter(|(r, _)| *r <= row);
        for (r, c) in iter {
            if self.groups[r][c] == g {
                self.col_quota[c].air -= 1;
                self.row_quota[r].air -= 1;
                self.cells[r][c] = Cell::Air;
                self.dirty = true;
            }
        }
    }

    pub fn fill_air(&mut self) {
        for r in 0..self.size {
            for c in 0..self.size {
                if self.cells[r][c] == Cell::None {
                    self.cells[r][c] = Cell::Air;
                }
            }
        }
    }

    pub fn is_solved(&self) -> bool {
        (0..self.size).all(|i| {
            self.row_quota[i].is_solved() && self.col_quota[i].is_solved()
        })
    }

    pub fn is_valid(&self) -> bool {
        (0..self.size).all(|i| {
            self.row_quota[i].is_valid() && self.col_quota[i].is_valid()
        })
    }

    pub fn next_none(&self, r: usize, c: usize) -> Option<(usize, usize)> {
        let start = r * self.size + c;
        for r in r..self.size {
            for c in 0..self.size {
                if r * self.size + c <= start {
                    continue;
                }
                if self.cells[r][c] == Cell::None {
                    return Some((r, c));
                }
            }
        }
        None
    }

    pub fn first_none(&self) -> Option<(usize, usize)> {
        for r in 0..self.size {
            for c in 0..self.size {
                if self.cells[r][c] == Cell::None {
                    return Some((r, c));
                }
            }
        }
        None
    }

    fn next(&self, r: usize, c: usize) -> Option<(usize, usize)> {
        match (r + 1 >= self.size, c + 1 >= self.size) {
            (true, true) => None,
            (true, false) => Some((r, c + 1)),
            (false, true) => Some((r + 1, 0)),
            (false, false) => Some((r, c + 1)),
        }
    }

    fn row_freq(&self, row: usize) -> Vec<usize> {
        let (mut freq, g) = (vec![0; self.group_count + 1], self.groups);
        (0..self.size).for_each(|col| freq[g[row][col] as usize] += 1);
        freq
    }

    fn col_freq(&self, col: usize) -> Vec<usize> {
        let (mut freq, g) = (vec![0; self.group_count + 1], self.groups);
        (0..self.size).for_each(|row| freq[g[row][col] as usize] += 1);
        freq
    }

    fn forcing_move(&mut self) -> bool {
        let g = self.groups;
        let n = self.size;

        // search rows for forcing moves
        for row in 0..n {
            if self.row_quota[row].water == 0 {
                for col in 0..n {
                    if self.cells[row][col].is_none() {
                        self.pour_air(row, col);
                    }
                }
            }
            if self.row_quota[row].air == 0 {
                for col in 0..n {
                    if self.cells[row][col].is_none() {
                        self.pour_water(row, col);
                    }
                }
            }
            if self.row_quota[row].water == 1 {
                let freq = self.row_freq(row);
                for col in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && self.cells[row][col].is_none()
                    {
                        self.pour_air(row, col);
                    }
                }
            }
            if self.row_quota[row].air == 1 {
                let freq = self.row_freq(row);
                for col in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && self.cells[row][col].is_none()
                    {
                        self.pour_water(row, col);
                    }
                }
            }
        }

        // search columns for forcing moves
        for col in 0..n {
            if self.col_quota[col].water == 0 {
                for row in 0..n {
                    if self.cells[row][col].is_none() {
                        self.pour_air(row, col);
                    }
                }
            }
            if self.col_quota[col].air == 0 {
                for row in 0..n {
                    if self.cells[row][col].is_none() {
                        self.pour_water(row, col);
                    }
                }
            }
            if self.col_quota[col].water == 1 {
                let freq = self.col_freq(col);
                for row in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && self.cells[row][col].is_none()
                    {
                        self.pour_air(row, col);
                    }
                }
            }
            if self.col_quota[col].air == 1 {
                let freq = self.col_freq(col);
                for row in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && self.cells[row][col].is_none()
                    {
                        self.pour_water(row, col);
                    }
                }
            }
        }

        false
    }

    fn fallback(self, fallback: &Grid<'a>) -> Grid<'a> {
        match self.is_valid() {
            true => self,
            false => fallback.clone(),
        }
    }

    fn _solve(mut self) -> Option<Grid<'a>> {
        println!("solve():\n{:?}", self);
        if self.is_valid() && self.is_solved() {
            self.fill_air();
            return Some(self);
        }

        let n = self.size;
        let g = self.groups;
        let mut next = self.clone();

        macro_rules! recurse {
            () => {
                next = next.fallback(&self);
                if next.dirty {
                    next.dirty = false;
                    return next._solve();
                }
            };
        }

        // Row ran out of water. Fill it all with air.
        for row in 0..n {
            if next.row_quota[row].water == 0 {
                for col in 0..n {
                    if next.cells[row][col].is_none() {
                        next.pour_air(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Row ran out of air. Fill it all with water.
        for row in 0..n {
            if next.row_quota[row].air == 0 {
                for col in 0..n {
                    if next.cells[row][col].is_none() {
                        next.pour_water(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Row has only one water left to allocate.
        for row in 0..n {
            if next.row_quota[row].water == 1 {
                let freq = next.row_freq(row);
                for col in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && next.cells[row][col].is_none()
                    {
                        next.pour_air(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Row has only one air left to allocate.
        for row in 0..n {
            if next.row_quota[row].air == 1 {
                let freq = next.row_freq(row);
                for col in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && next.cells[row][col].is_none()
                    {
                        next.pour_water(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Column ran out of water. Fill it all with air.
        for col in 0..n {
            if next.col_quota[col].water == 0 {
                for row in 0..n {
                    if next.cells[row][col].is_none() {
                        next.pour_air(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Column ran out of air. Fill it all with water.
        for col in 0..n {
            if next.col_quota[col].air == 0 {
                for row in 0..n {
                    if next.cells[row][col].is_none() {
                        next.pour_water(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Column has only one water left to allocate.
        for col in 0..n {
            if next.row_quota[col].water == 1 {
                let freq = next.col_freq(col);
                for row in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && next.cells[row][col].is_none()
                    {
                        next.pour_air(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        // Column has only one air left to allocate.
        for col in 0..n {
            if next.col_quota[col].air == 1 {
                println!("one air left in col {}", col);
                let freq = next.col_freq(col);
                println!("{:?}", freq);
                for row in 0..n {
                    if freq[g[row][col] as usize] > 1
                        && next.cells[row][col].is_none()
                    {
                        println!("POUR WATER AT COL {}", col);
                        next.pour_water(row, col);
                        next = next.fallback(&self);
                    }
                }
            }
        }
        recurse!();

        println!("dirty: {}", next.dirty);
        None
    }

    pub fn solve(&self) -> Option<Grid<'a>> {
        self.clone()._solve()
    }
}
