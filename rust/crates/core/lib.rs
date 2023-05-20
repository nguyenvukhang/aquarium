pub mod error;

use error::Result;
use grid::Grid;
use serde::Deserialize;

#[derive(Deserialize)]
struct Sums {
    cols: Vec<i32>,
    rows: Vec<i32>,
}

#[derive(Deserialize)]
struct JsonGame {
    sums: Sums,
    matrix: Vec<Vec<usize>>,
}

#[derive(Debug)]
pub struct Game {
    col_sums: Vec<i32>,
    row_sums: Vec<i32>,
    group_matrix: Vec<Vec<usize>>,
}

impl Game {
    /// Create a new game from rust native data structures.
    pub fn new(
        col_sums: Vec<i32>,
        row_sums: Vec<i32>,
        group_matrix: Vec<Vec<usize>>,
    ) -> Self {
        Self { col_sums, row_sums, group_matrix }
    }

    /// Pull a game from the actual aquarium source using a game id.
    pub async fn from_id(id: &str) -> Result<Self> {
        let url = "https://aquarium2.vercel.app/api/get?id=";
        let res = reqwest::get(format!("{url}{id}")).await?;
        let data = res.json::<JsonGame>().await?;
        Ok(Self::new(data.sums.cols, data.sums.rows, data.matrix))
    }

    /// Solve the game.
    pub fn solve(&self) -> (Grid, bool) {
        let mut grid =
            Grid::new(&self.col_sums, &self.row_sums, &self.group_matrix);
        let solved = grid.solve();
        (grid, solved)
    }
}

impl Game {
    /// Debug run
    pub fn debug_run(&self) {
        let grid =
            Grid::new(&self.col_sums, &self.row_sums, &self.group_matrix);
        grid.debug_run()
    }
}
