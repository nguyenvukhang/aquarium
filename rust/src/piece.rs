#[derive(Debug)]
pub struct Piece {
    pub group: u8,
    pub height: usize,
    pub water_level: usize,
    coords: Vec<Vec<usize>>,
}

impl Piece {
    pub fn new(group: u8, coords: &Vec<Vec<usize>>) -> Self {
        let height = coords.iter().filter(|v| !v.is_empty()).count();
        Self { group, water_level: 0, height, coords: coords.clone() }
    }

    fn flat(&self) -> Vec<(usize, usize)> {
        let i = self.coords.iter().enumerate();
        i.flat_map(|(r, c)| c.iter().map(move |c| (r, *c))).collect()
    }

    pub fn at_row(&self, row: usize) -> Option<usize> {
        self.coords[row].get(0).map(|v| *v)
    }

    pub fn at_col(&self, col: usize) -> Option<usize> {
        for i in (0..self.coords.len()).rev() {
            if self.coords[i].contains(&col) {
                return Some(i);
            }
        }
        None
    }

    pub fn pour_water(&self, height: usize) -> Option<Vec<(usize, usize)>> {
        if height > self.height {
            return None;
        }
        Some(
            self.coords
                .iter()
                .skip_while(|v| v.is_empty())
                .skip(self.height - height)
                .enumerate()
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }

    pub fn pour_water_at_row(&self, row: usize) -> Option<Vec<(usize, usize)>> {
        Some(
            self.coords
                .iter()
                .skip(row)
                .skip_while(|v| v.is_empty())
                .enumerate()
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }

    pub fn eq_and_below(&self, row: usize) -> Option<Vec<(usize, usize)>> {
        Some(
            self.coords
                .iter()
                .enumerate()
                .skip(row)
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }

    pub fn eq_and_above(&self, row: usize) -> Option<Vec<(usize, usize)>> {
        Some(
            self.coords
                .iter()
                .enumerate()
                .take(row + 1)
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }

    // get the minimum squares to fill if water is to be poured at a certian column
    pub fn pour_water_at_col(&self, col: usize) -> Vec<(usize, usize)> {
        let coords = self.flat();
        // highest row visually is numerically the largest
        let mut highest_row = usize::MAX;
        for (row, _) in coords.iter().filter(|v| v.1 == col) {
            if row < &highest_row {
                highest_row = *row
            }
        }
        coords.into_iter().filter(|(r, _)| *r >= highest_row).collect()
    }

    // get the minimum squares to fill if air is to be poured at a certian column
    pub fn pour_air_at_col(&self, col: usize) -> Vec<(usize, usize)> {
        let coords = self.flat();
        // highest row visually is numerically the largest
        let mut lowest_row = 0usize;
        for (row, _) in coords.iter().filter(|v| v.1 == col) {
            if row > &lowest_row {
                lowest_row = *row
            }
        }
        coords.into_iter().filter(|(r, _)| *r <= lowest_row).collect()
    }
}
