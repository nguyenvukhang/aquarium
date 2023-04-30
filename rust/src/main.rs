use aquarium::grid::Grid;
use aquarium::grid2;

fn run(cols: Vec<i32>, rows: Vec<i32>, groups: Vec<Vec<u8>>) {
    let grid = Grid::new(&groups, &cols, &rows);
    let next = grid.solve();
    if let Some(v) = next {
        println!("Successful solve!");
        println!("{:?}", v);
    } else {
        println!("Unable to solve!");
    }
}

#[test]
fn solve_test() {
    use aquarium::cell::Cell;
    use Cell::{Air as x, Water as W};
    let cols = vec![4, 4, 5, 4, 3, 1];
    let rows = vec![3, 4, 4, 5, 1, 4];
    let groups = vec![
        vec![1, 1, 1, 2, 3, 3],
        vec![1, 1, 1, 2, 3, 3],
        vec![1, 4, 4, 2, 3, 3],
        vec![1, 5, 5, 5, 5, 3],
        vec![6, 6, 6, 6, 5, 3],
        vec![6, 6, 5, 5, 5, 3],
    ];
    let mut grid = Grid::new(&groups, &cols, &rows);
    let result = grid.solve();
    grid.cells = vec![
        vec![W, W, W, x, x, x],
        vec![W, W, W, W, x, x],
        vec![W, W, W, W, x, x],
        vec![W, W, W, W, W, x],
        vec![x, x, x, x, W, x],
        vec![x, x, W, W, W, W],
    ];
    assert_eq!(result.map(|v| v.cells), Some(grid.cells))
}

fn main() {
    grid2::run();
    println!("hello world!")
}
