use aquarium::error::Result;
use aquarium::grid::builder;
use aquarium::grid::Grid;
use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct Sums {
    cols: Vec<i32>,
    rows: Vec<i32>,
}

#[derive(Debug, Deserialize)]
struct RawJson {
    id: String,
    sums: Sums,
    matrix: Vec<Vec<u8>>,
    play: String,
}

async fn get_puzzle(id: &str) -> Result<()> {
    let url = "https://aquarium2.vercel.app/api/get?id=";
    let res = reqwest::get(format!("{url}{id}")).await?;
    println!("successful response");
    let data = res.json::<RawJson>().await?;
    let (cols, rows) = (data.sums.cols, data.sums.rows);
    let mut coords = vec![];
    let pieces = builder::pieces(6, &data.matrix, &mut coords);
    let mut grid = Grid::new(&cols, &rows, pieces, &data.matrix);
    grid.solve();
    grid.debug();
    // println!("{:?}", grid);

    Ok(())
}

#[tokio::main]
async fn main() {
    println!("Aquarium-rust: start execution...");
    // match get_puzzle("MDo4LDQ3MSwzNDk=").await {
    match get_puzzle("Mjo4LDgzMiw5NTQ=").await {
        Ok(v) => println!("Ok!"),
        Err(e) => eprintln!("Err: {e:?}"),
    }
    // grid::run();
    println!("Aquarium-rust: done execution!");
}
