use std::fmt;

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
