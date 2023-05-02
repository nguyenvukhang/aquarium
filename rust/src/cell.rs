use std::fmt;

#[derive(Clone, PartialEq, Eq)]
pub enum Cell {
    Water,
    Air,
    None,
}

impl Cell {
    pub fn as_char(&self) -> char {
        match self {
            Cell::Water => '■',
            Cell::Air => '×',
            Cell::None => ' ',
        }
    }

    pub fn is_none(&self) -> bool {
        *self == Cell::None
    }
}

impl fmt::Debug for Cell {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.as_char())
    }
}
