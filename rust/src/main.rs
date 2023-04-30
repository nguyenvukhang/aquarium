use aquarium::error::Result;
use aquarium::Game;

async fn try_main(id: &str) -> Result<()> {
    let game = Game::from_id(id).await?;
    let (grid, solved) = game.solve();
    match solved {
        true => println!("Successful solve!"),
        false => println!("Failed to solve."),
    }
    grid.debug();
    Ok(())
}

#[tokio::main]
async fn main() {
    let id = match std::env::args().skip(1).next() {
        Some(v) => v,
        None => {
            println!("Please provide an id to test");
            return;
        }
    };
    match try_main(&id).await {
        Ok(_) => {}
        Err(e) => println!("Error: {e:?}"),
    };
    println!("aquarium-rust: done execution!");
}
