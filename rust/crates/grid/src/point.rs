use std::fmt;

#[derive(Clone, PartialEq, Eq, Copy)]
pub struct Point {
    pub row: usize,
    pub col: usize,
}

impl<'a> fmt::Debug for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.row, self.col)
    }
}

impl Point {
    pub fn new(row: usize, col: usize) -> Self {
        Self { row, col }
    }
}
