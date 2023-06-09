use aquarium::error::Result;
use aquarium::Game;

async fn try_main(id: &str) -> Result<()> {
    let game = Game::from_id(id).await?;
    let (grid, solved) = game.solve();
    match solved {
        true => println!("Successful solve!"),
        false => println!("Failed to solve."),
    }
    println!("{:?}", grid);
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

#[cfg(test)]
mod tests {
    use aquarium::Game;

    macro_rules! test {
        (ignore, $name:ident, $cols:expr, $rows:expr, $grps:expr) => {
            #[ignore]
            #[test]
            fn $name() {
                test!($cols, $rows, $grps)
            }
        };
        ($name:ident, $cols:expr, $rows:expr, $grps:expr) => {
            #[test]
            fn $name() {
                test!($cols, $rows, $grps)
            }
        };
        ($cols:expr, $rows:expr, $grps:expr) => {{
            let (cols, rows) = ($cols.to_vec(), $rows.to_vec());
            let grps = $grps.iter().map(|v| v.to_vec()).collect();
            let game = Game::new(cols, rows, grps);
            let (grid, solved) = game.solve();
            if !solved {
                eprintln!("{:?}", grid);
            }
            assert!(solved);
        }};
    }

    test!(
        easy_6x6_v1, // MDoxMiw2NDUsNjY1
        [4, 5, 2, 2, 2, 2],
        [5, 2, 4, 2, 2, 2],
        [
            [1, 1, 2, 2, 2, 3],
            [1, 1, 3, 3, 3, 3],
            [4, 1, 5, 3, 5, 3],
            [4, 1, 5, 5, 5, 6],
            [5, 1, 1, 5, 6, 6],
            [5, 5, 5, 5, 6, 6]
        ]
    );

    test!(
        ignore,
        normal_6x6_v1, // MToxNSwxNjcsMDM3
        [4, 2, 1, 3, 5, 2],
        [1, 2, 1, 3, 5, 5],
        [
            [1, 1, 1, 1, 2, 3],
            [1, 4, 4, 4, 2, 3],
            [5, 4, 4, 6, 2, 3],
            [5, 4, 6, 6, 3, 3],
            [4, 4, 7, 3, 3, 8],
            [9, 4, 7, 8, 8, 8]
        ]
    );

    test!(
        normal_6x6_v2, // MToyLDE5NiwwNjk=
        [2, 4, 3, 1, 4, 5],
        [4, 1, 4, 4, 4, 2],
        [
            [1, 1, 1, 1, 2, 2],
            [3, 4, 2, 2, 2, 5],
            [3, 4, 4, 2, 5, 5],
            [4, 4, 6, 2, 5, 5],
            [7, 6, 6, 2, 8, 8],
            [7, 7, 7, 7, 9, 9]
        ]
    );

    test!(
        ignore,
        hard_6x6_v2, // MjozLDIyMSw1OTU=
        [3, 4, 4, 5, 4, 5],
        [4, 4, 5, 5, 2, 5],
        [
            [1, 2, 2, 3, 4, 5],
            [1, 6, 6, 3, 3, 5],
            [7, 7, 8, 8, 9, 10],
            [11, 11, 12, 12, 9, 10],
            [13, 14, 14, 15, 15, 16],
            [13, 17, 17, 18, 18, 16]
        ]
    );

    test!(
        ignore,
        easy_10x10_v1, // Mzo2LDU3MSw2MjM=
        [6, 7, 8, 5, 3, 7, 7, 7, 6, 3],
        [4, 7, 8, 7, 6, 6, 3, 4, 6, 8],
        [
            [1, 1, 1, 2, 3, 4, 4, 4, 4, 5],
            [1, 1, 2, 2, 3, 4, 5, 5, 4, 5],
            [1, 1, 1, 2, 3, 3, 5, 5, 5, 5],
            [1, 6, 1, 2, 3, 3, 5, 7, 7, 5],
            [8, 6, 6, 3, 3, 5, 5, 7, 7, 9],
            [8, 6, 6, 3, 10, 5, 7, 7, 7, 9],
            [8, 8, 6, 3, 10, 11, 11, 11, 9, 9],
            [8, 8, 8, 12, 12, 11, 9, 9, 9, 13],
            [8, 8, 8, 12, 12, 11, 14, 9, 9, 13],
            [8, 8, 8, 12, 14, 14, 14, 9, 13, 13]
        ]
    );
}
