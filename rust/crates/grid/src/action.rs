use crate::{Cell, Point};

#[derive(Debug)]
pub struct Action {
    pour_type: Cell,
    point: Point,
}

impl Action {
    pub fn new(pour_type: Cell, point: Point) -> Self {
        Self { pour_type, point }
    }
}
