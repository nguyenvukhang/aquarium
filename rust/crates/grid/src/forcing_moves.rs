use crate::{Checkable, Grid, Instance};

/// Forcing move implementations
impl Grid {
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
                    inst.pour_water(pp);
                    changed = true;
                }

                // Try to pour water at the point. If the instance
                // turns invalid immediately, when we are forced to
                // pour air there
                let delta = inst.pour_water(pp);
                if inst.is_valid() {
                    inst.undo_pour_water(delta);
                } else {
                    inst.undo_pour_water(delta);
                    inst.pour_air(pp);
                    changed = true;
                }
            }
        }
    }
}
