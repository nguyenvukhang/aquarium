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
    pub fn vec(water_limit: &Vec<i32>) -> Vec<Self> {
        let size = water_limit.len();
        water_limit.iter().map(|v| Quota::new(*v, size)).collect()
    }

    pub fn new(water_limit: i32, size: usize) -> Self {
        Self { water: water_limit, air: size as i32 - water_limit }
    }

    pub fn all_valid(rows: &Vec<Quota>, cols: &Vec<Quota>) -> bool {
        rows.iter().all(|v| v.is_valid()) && cols.iter().all(|v| v.is_valid())
    }
}

pub trait Checkable {
    fn is_valid(&self) -> bool;
    fn is_solved(&self) -> bool;
}

impl Checkable for Quota {
    fn is_solved(&self) -> bool {
        self.water == 0 && self.air == 0
    }

    fn is_valid(&self) -> bool {
        self.water >= 0 && self.air >= 0
    }
}

impl Checkable for Vec<Quota> {
    fn is_solved(&self) -> bool {
        self.iter().all(|v| v.is_solved())
    }

    fn is_valid(&self) -> bool {
        self.iter().all(|v| v.is_valid())
    }
}
