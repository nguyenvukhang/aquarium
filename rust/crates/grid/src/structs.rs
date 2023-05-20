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

#[derive(Clone, PartialEq, Eq)]
pub struct Cell {
    pub group: usize,
    pub state: State,
}

impl Cell {
    pub fn new(group: usize) -> Self {
        Self { group, state: State::None }
    }
}

impl fmt::Debug for Cell {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {:?})", self.group, self.state)
    }
}

#[derive(Clone, PartialEq, Eq)]
pub enum State {
    Water,
    Air,
    None,
}

impl State {
    pub fn as_char(&self) -> char {
        match self {
            State::Water => '■',
            State::Air => '×',
            State::None => ' ',
        }
    }

    pub fn is_none(&self) -> bool {
        self == &State::None
    }
}

impl fmt::Debug for State {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.as_char())
    }
}
