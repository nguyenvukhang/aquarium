use crate::{Checkable, Point, PourPoint, Quota, State};
use std::fmt;

/// An instance of a game is meant to be as lightweight as possible,
/// to be copied as cheaply as possible when backtracking.
#[derive(Clone)]
pub struct Instance<'a> {
    pub state: Vec<Vec<State>>,
    qrow: Vec<Quota>,
    qcol: Vec<Quota>,
    groups: &'a Vec<Vec<usize>>,
}

const JOIN_UP: &str = "┼│├┤┌┬┐";
const JOIN_RIGHT: &str = "┼├─┌┬└┴";

impl<'a> Instance<'a> {
    pub fn new(
        groups: &'a Vec<Vec<usize>>,
        qrow: &Vec<Quota>,
        qcol: &Vec<Quota>,
    ) -> Self {
        let size = groups.len();
        let state = (0..size)
            .map(|_| (0..size).map(|_| State::None).collect())
            .collect();
        Self { state, groups, qrow: qrow.clone(), qcol: qcol.clone() }
    }

    pub fn size(&self) -> usize {
        self.groups.len()
    }

    /// Pours water and returns the affected points
    pub fn pour_water<'b>(&mut self, point: &'b PourPoint) -> Vec<&'b Point> {
        let mut affected = vec![];
        for p in &point.water_flow {
            match self.state[p.row][p.col] {
                State::None => {
                    self.state[p.row][p.col] = State::Water;
                    self.qrow[p.row].water -= 1;
                    self.qcol[p.col].water -= 1;
                    affected.push(p)
                }
                _ => continue,
            }
        }
        affected
    }

    /// Pours air and returns the affected points
    pub fn pour_air<'b>(&mut self, point: &'b PourPoint) -> Vec<&'b Point> {
        let mut affected = vec![];
        for p in &point.air_flow {
            match self.state[p.row][p.col] {
                State::None => {
                    self.state[p.row][p.col] = State::Air;
                    self.qrow[p.row].air -= 1;
                    self.qcol[p.col].air -= 1;
                    affected.push(p)
                }
                _ => continue,
            }
        }
        affected
    }

    pub fn undo_pour_water(&mut self, points: Vec<&Point>) {
        for p in points {
            self.state[p.row][p.col] = State::None;
            self.qrow[p.row].water += 1;
            self.qcol[p.col].water += 1;
        }
    }

    pub fn undo_pour_air(&mut self, points: Vec<&Point>) {
        for p in points {
            self.state[p.row][p.col] = State::None;
            self.qrow[p.row].air += 1;
            self.qcol[p.col].air += 1;
        }
    }
}

impl<'a> Checkable for Instance<'a> {
    fn is_valid(&self) -> bool {
        self.qcol.is_valid() && self.qrow.is_valid()
    }

    fn is_solved(&self) -> bool {
        self.qcol.is_solved() && self.qrow.is_solved()
    }
}

/// Debugging methods
impl<'a> Instance<'a> {
    /// Get the surrounding groups of a border point.
    /// Bounds belong to group 0.
    /// [<upper-left>, <upper-right>, <lower-left>, <lower-right>]
    fn surrounding_groups(&self, r: usize, c: usize) -> [usize; 4] {
        let (n, g) = (self.size(), &self.groups);
        //           ↖︎  ↗︎  ↙︎  ↘︎
        let mut t = [0, 0, 0, 0];
        if r > 0 {
            if c > 0 {
                t[0] = g[r - 1][c - 1]; // ↖︎
            }
            if c < n {
                t[1] = g[r - 1][c]; // ↗︎
            }
        }
        if r < n {
            if c > 0 {
                t[2] = g[r][c - 1]; // ↙︎
            }
            if c < n {
                t[3] = g[r][c]; // ↘︎
            }
        }
        t
    }

    fn border(&self, r: usize, c: usize) -> char {
        let n = self.size();
        let [ul, ur, ll, lr] = self.surrounding_groups(r, c);
        // handle bounds
        if r == 0 {
            return match c {
                0 => '┌',
                v if v == n => '┐',
                _ if ll == lr => '─',
                _ => '┬',
            };
        }
        if r == n {
            return match c {
                0 => '└',
                v if v == n => '┘',
                _ if ul == ur => '─',
                _ => '┴',
            };
        }
        if c == 0 {
            return if ur == lr { '│' } else { '├' };
        }
        if c == n {
            return if ul == ll { '│' } else { '┤' };
        }
        // handle the rest
        if ul == ur && ur == ll && ll == lr {
            return ' ';
        }
        if ul == ll && ur == lr {
            return '│';
        }
        if ul == ur && ll == lr {
            return '─';
        }
        if ul == ur {
            if ul == ll {
                return '┌';
            }
            if ur == lr {
                return '┐';
            }
            return '┬';
        }
        if ll == lr {
            if ul == ll {
                return '└';
            }
            if ur == lr {
                return '┘';
            }
            return '┴';
        }
        if ul == ll {
            return '├';
        }
        if ur == lr {
            return '┤';
        }
        return '┼';
    }

    fn join_state_line(
        &self,
        borders: &Vec<char>,
        states: &Vec<State>,
    ) -> String {
        let mut result = String::from("│");
        for i in 0..self.size() {
            result.push(' ');
            result.push(states[i].as_char());
            result.push(' ');
            result.push(match JOIN_UP.contains(borders[i + 1]) {
                true => '│',
                false => ' ',
            });
        }
        result
    }

    fn join_border_line(&self, borders: &Vec<char>) -> String {
        let mut result = String::new();
        for i in 0..self.size() {
            result.push(borders[i]);
            result.push_str(match JOIN_RIGHT.contains(borders[i]) {
                true => "───",
                false => "   ",
            })
        }
        result.push(borders[borders.len() - 1]);
        result
    }
}

impl<'a> fmt::Debug for Instance<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut stdout = String::new();
        let mut print = |v: String| stdout.push_str(&(v + "\n"));
        let i = || (0..self.size() + 1);
        print(format!("         {:?}", self.qcol));
        let borders: Vec<Vec<char>> =
            i().map(|r| i().map(|c| self.border(r, c)).collect()).collect();
        for i in 0..self.size() + 1 {
            print(format!("         {}", self.join_border_line(&borders[i])));
            if i < self.size() {
                print(format!(
                    "{:>8} {}",
                    format!("{:?}", self.qrow[i]),
                    self.join_state_line(&borders[i], &self.state[i])
                ));
            }
        }
        stdout.pop();
        write!(f, "Instance {{\n{stdout}\n}}")
    }
}
