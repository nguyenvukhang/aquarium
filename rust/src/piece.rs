use std::iter::Enumerate;

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

    pub fn at_row(&self, row: usize) -> Option<usize> {
        self.coords[row].get(0).map(|v| *v)
    }

    fn enumerate(&self) -> Enumerate<std::slice::Iter<'_, Vec<usize>>> {
        self.coords.iter().enumerate()
    }

    pub fn eq_and_below(&self, row: usize) -> Option<Vec<(usize, usize)>> {
        Some(
            self.enumerate()
                .skip(row)
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }

    pub fn eq_and_above(&self, row: usize) -> Option<Vec<(usize, usize)>> {
        Some(
            self.enumerate()
                .take(row + 1)
                .flat_map(|(r, cols)| cols.iter().map(move |c| (r, *c)))
                .collect(),
        )
    }
}
