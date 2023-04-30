pub mod cell;
pub mod error;
pub mod grid;
pub mod groups;
pub mod piece;
pub mod quota;

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
    matrix: Vec<Vec<u8>>,
    // id: String,
    // play: String,
}

#[derive(Debug)]
pub struct Game {
    col_sums: Vec<i32>,
    row_sums: Vec<i32>,
    group_matrix: Vec<Vec<u8>>,
}

impl Game {
    pub fn new(
        col_sums: Vec<i32>,
        row_sums: Vec<i32>,
        group_matrix: Vec<Vec<u8>>,
    ) -> Self {
        Self { col_sums, row_sums, group_matrix }
    }

    pub async fn from_id(id: &str) -> Result<Self> {
        let url = "https://aquarium2.vercel.app/api/get?id=";
        let res = reqwest::get(format!("{url}{id}")).await?;
        let data = res.json::<JsonGame>().await?;
        Ok(Self::new(data.sums.cols, data.sums.rows, data.matrix))
    }

    pub fn solve(&self) -> (Grid, bool) {
        let mut grid =
            Grid::new(&self.col_sums, &self.row_sums, &self.group_matrix);
        let solved = grid.solve();
        (grid, solved)
    }
}
