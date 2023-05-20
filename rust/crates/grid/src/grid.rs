use crate::{Cell, Checkable, Instance, PourPoint, Quota};

pub struct Grid {
    pub(crate) qcol: Vec<Quota>,
    pub(crate) qrow: Vec<Quota>,
    pub(crate) cells: Vec<Vec<Cell>>,
    pub(crate) pour_points: Vec<PourPoint>,
    pub(crate) groups: Vec<Vec<usize>>,
}

impl Grid {
    /// Length of the grid along one dimension
    pub fn size(&self) -> usize {
        self.qcol.len()
    }

    /// Make all forcing moves. Might lead to an invalid state.
    pub fn make_all_forcing_moves(&self, inst: &mut Instance) {
        let mut changed = true;
        while changed {
            changed = false;
            for pp in &self.pour_points {
                // Try to pour air at the point. If the instance
                // turns invalid immediately, when we are forced to
                // pour water there
                let delta = inst.pour_air(pp);
                if inst.is_valid() {
                    inst.undo_pour_air(delta);
                } else {
                    inst.undo_pour_air(delta);
                    changed |= !inst.pour_water(pp).is_empty();
                }
                // Try to pour water at the point. If the instance
                // turns invalid immediately, when we are forced to
                // pour air there
                let delta = inst.pour_water(pp);
                if inst.is_valid() {
                    inst.undo_pour_water(delta);
                } else {
                    inst.undo_pour_water(delta);
                    changed |= !inst.pour_air(pp).is_empty();
                }
            }
            if !inst.is_valid() {
                return;
            }
            // println!("FORCING {:?}", inst);
        }
    }
}
