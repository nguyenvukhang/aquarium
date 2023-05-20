use crate::State;
use std::fmt;

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
