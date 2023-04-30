use std::fmt;

#[derive(Clone, PartialEq, Eq)]
pub struct Quota {
    pub water: i32,
    pub air: i32,
}

impl<'a> fmt::Debug for Quota {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{},{}", self.water, self.air)
    }
}

impl Quota {
    pub fn new(water_limit: i32, size: usize) -> Self {
        Self { water: water_limit, air: size as i32 - water_limit }
    }

    pub fn is_solved(&self) -> bool {
        self.water == 0 && self.air == 0
    }

    pub fn is_valid(&self) -> bool {
        self.water >= 0 && self.air >= 0
    }

    pub fn all_valid(rows: &Vec<Quota>, cols: &Vec<Quota>) -> bool {
        rows.iter().all(|v| v.is_valid()) && cols.iter().all(|v| v.is_valid())
    }
}
