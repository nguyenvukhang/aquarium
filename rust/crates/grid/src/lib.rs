mod action;
pub mod builder;
mod cell;
mod debug;
mod forcing_moves;
mod grid;
mod instance;
mod point;
mod pour_point;
mod quota;
mod state;

use action::Action;
use cell::Cell;
use point::Point;
use quota::{Checkable, Quota};
use state::State;

pub use grid::Grid;

use instance::Instance;
use pour_point::PourPoint;

/// Exposed API
impl Grid {
    pub fn new(
        cols: &Vec<i32>,
        rows: &Vec<i32>,
        groups: &Vec<Vec<usize>>,
    ) -> Self {
        let cells = groups
            .iter()
            .map(|row| row.iter().map(|group| Cell::new(*group)).collect())
            .collect();
        let qrow = Quota::vec(rows);
        let qcol = Quota::vec(cols);
        let key_points = builder::get_key_points(&cells);
        let pour_points =
            key_points.into_iter().map(|v| PourPoint::new(v, &cells)).collect();

        Self { cells, qrow, qcol, pour_points, groups: groups.clone() }
    }

    // returns true on successful solve
    pub fn solve(&mut self) -> bool {
        let mut inst = Instance::new(&self.groups, &self.qrow, &self.qcol);
        self.make_all_forcing_moves(&mut inst);
        for r in 0..self.size() {
            for c in 0..self.size() {
                self.cells[r][c].state = inst.state[r][c].clone()
            }
        }
        inst.is_solved()
    }
}

impl Grid {
    pub fn debug_run(&self) {
        println!("hello world!");
        self.debug();

        let mut inst = Instance::new(&self.groups, &self.qrow, &self.qcol);

        self.make_all_forcing_moves(&mut inst);

        println!("INSTANCE: {inst:?}");

        println!("{:?}", self.pour_points[2])
    }
}
