use aquarium::error::Result;
use aquarium::Game;

async fn try_main() -> Result<()> {
    let game = Game::from_id("MzoxLDU5OSwxOTc=").await?;
    game.solve();
    Ok(())
}

#[tokio::main]
async fn main() {
    match try_main().await {
        Ok(_) => {}
        Err(e) => println!("Error: {e:?}"),
    }
    println!("aquarium-rust: done execution!");
}
