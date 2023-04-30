use crate::cell::Cell;
use crate::grid::Grid;

impl<'a> Grid<'a> {
    pub fn max_g(&self) -> u8 {
        *self.groups.iter().flat_map(|r| r.iter().max()).max().unwrap_or(&0)
    }

    /// Returns Vec<(group, water count, air count)>
    pub fn row_freqs(&mut self, row: usize) -> Vec<(u8, usize, usize)> {
        let n = self.max_g() as usize + 1;
        let mut f = Vec::with_capacity(n);
        (0..n).for_each(|i| f.push((i as u8, 0, 0)));
        for col in 0..self.size() {
            let group = self.groups[row][col];
            match self.cells[row][col] {
                Cell::Water => f[group as usize].1 += 1,
                Cell::Air => f[group as usize].2 += 1,
                Cell::None => {}
            }
        }
        f.into_iter().filter(|v| v.1 > 0 || v.2 > 0).collect()
    }
}
