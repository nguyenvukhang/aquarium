use crate::cell::Cell;
use crate::grid::Grid;
use std::fmt;

/// Debugging methods
impl<'a> Grid<'a> {
    /// Get the surrounding groups of a border point.
    /// Bounds belong to group 0.
    /// [<upper-left>, <upper-right>, <lower-left>, <lower-right>]
    fn surrounding_groups(&self, r: usize, c: usize) -> [u8; 4] {
        let (n, g) = (self.size(), self.groups);
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
        if r < self.size() {
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

    fn join_cell_line(&self, borders: &Vec<char>, cells: &Vec<Cell>) -> String {
        let mut result = String::from("│");
        let c = "┼│├┤┌┬┐";
        for i in 0..self.size() {
            result.push(' ');
            result.push(cells[i].as_char());
            result.push(' ');
            result.push(if c.contains(borders[i + 1]) { '│' } else { ' ' })
        }
        result
    }

    fn join_border_line(&self, borders: &Vec<char>) -> String {
        let mut result = String::new();
        let c = "┼├─┌┬└┴";
        for i in 0..self.size() {
            result.push(borders[i]);
            result.push_str(if c.contains(borders[i]) {
                "───"
            } else {
                "   "
            })
        }
        result.push(borders[borders.len() - 1]);
        result
    }
}

impl<'a> fmt::Debug for Grid<'a> {
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
                    self.join_cell_line(&borders[i], &self.cells[i])
                ));
            }
        }
        stdout.pop();
        write!(f, "Grid {{\n{stdout}\n}}")
    }
}
