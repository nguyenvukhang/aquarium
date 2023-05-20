pub mod builder;
mod structs;
mod debug;
mod grid;
mod instance;
mod pour_point;
mod quota;

use structs::{Point, Cell, State};
use quota::{Checkable, Quota};

pub use grid::Grid;

use instance::Instance;
use pour_point::PourPoint;

use std::mem::swap;

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
        let pour_points = builder::get_key_points(&cells);

        Self { cells, qrow, qcol, pour_points, groups: groups.clone() }
    }

    pub fn backtrack(&self, inst: &mut Instance) -> bool {
        // println!(">>> RECURSE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

        self.make_all_forcing_moves(inst);

        if !inst.is_valid() {
            return false;
        }

        if inst.is_solved() {
            return true;
        }

        println!("after forcing moves: {inst:?}");

        // backtrack with water-pouring
        for point in self.pour_points.iter() {
            let delta = inst.pour_water(point);

            if delta.is_empty() || !inst.is_valid() {
                inst.undo_pour_water(delta);
                continue;
            }

            let mut copy = inst.clone();
            if self.backtrack(&mut copy) {
                swap(inst, &mut copy);
                return true;
            }
        }

        // backtrack with air-pouring (do from bottom for quicker elimination)
        for point in self.pour_points.iter().rev() {
            let delta = inst.pour_air(point);

            if delta.is_empty() || !inst.is_valid() {
                inst.undo_pour_air(delta);
                continue;
            }

            let mut copy = inst.clone();
            if self.backtrack(&mut copy) {
                swap(inst, &mut copy);
                return true;
            }
        }
        false
    }

    // returns true on successful solve
    pub fn solve(&mut self) -> bool {
        let mut inst = Instance::new(&self.groups, &self.qrow, &self.qcol);
        self.backtrack(&mut inst);

        // consolidation
        for r in 0..self.size() {
            for c in 0..self.size() {
                self.cells[r][c].state = inst.state[r][c].clone()
            }
        }
        self.qcol = inst.qcol.clone();
        self.qrow = inst.qrow.clone();
        inst.is_solved()
    }
}

impl Grid {
    pub fn debug_run(&self) {}
}
