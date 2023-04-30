mod builder;
mod freq;
mod mutate;

use crate::cell::Cell;
use crate::piece::Piece;
use crate::quota::Quota;

pub struct Grid2<'a> {
    pieces: Vec<Piece<'a>>,
    qcol: Vec<Quota>,
    qrow: Vec<Quota>,
    row_pieces: Vec<Vec<(u8, usize)>>,
    cells: Vec<Vec<Cell>>,
    groups: &'a Vec<Vec<u8>>,
}

impl<'a> Grid2<'a> {
    pub fn new(
        cols: &Vec<i32>,
        rows: &Vec<i32>,
        pieces: Vec<Piece<'a>>,
        groups: &'a Vec<Vec<u8>>,
    ) -> Self {
        let size = cols.len();
        let qcol = cols.iter().map(|v| Quota::new(*v, size)).collect();
        let qrow = rows.iter().map(|v| Quota::new(*v, size)).collect();

        let row_pieces = builder::row_pieces(size, groups);
        let cells = vec![vec![Cell::None; size]; size];

        Self { pieces, qcol, qrow, row_pieces, cells, groups }
    }

    fn size(&self) -> usize {
        self.qcol.len()
    }

    // execute one row-forcing move
    // returns true if a move is executed
    pub fn row_forcing_move(&mut self) -> bool {
        for row in 0..self.size() {
            // There is no need to fetch latest row frequencies
            // because by physics, the row frequencies will stay the
            // same (or be zero). If water is filled, the whole row
            // is water, and same with air.
            for i in 0..self.row_pieces[row].len() {
                let (group, freq) = self.row_pieces[row][i];
                let col = self.pieces[group as usize].at_row(row).unwrap();
                let cell = &self.cells[row][col];

                // Piece is already filled at this row.
                // Don't look for forcing moves on this piece at this
                // row.
                if !cell.is_none() {
                    continue;
                }

                // This means that filling the row with water will
                // break the water constraint. Hence, fill it with
                // air.
                if freq as i32 > self.qrow[row].water {
                    println!("FILL ROW {row} WITH AIR ({group})");
                    // println!("forcing! water overflow @ group {group}");
                    // self.debug();
                    let piece = &self.pieces[group as usize];
                    if let Some(d) = piece.eq_and_above(row) {
                        return self.to_air_many(&d);
                    }
                }

                // This means that filling the row with air will
                // break the air constraint. Hence, fill it with
                // air.
                if freq as i32 > self.qrow[row].air {
                    println!("FILL ROW {row} WITH WATER ({group})");
                    // println!("forcing! air overflow @ group {group}");
                    // self.debug();
                    let piece = &self.pieces[group as usize];
                    if let Some(d) = piece.eq_and_below(row) {
                        return self.to_water_many(&d);
                    }
                }
            }
        }
        false
    }

    // execute one column-forcing move
    // returns true if a move is executed
    pub fn column_forcing_move(&mut self) -> bool {
        for col in 0..self.size() {
            if self.qcol[col].water == 0 && self.qcol[col].air > 0 {
                // fill that entire column with air
                println!("FILL COLUMN {col} WITH AIR");
                let mut filled = false;
                for row in 0..self.size() {
                    filled |= self.to_air_smart(row, col);
                }
                if filled {
                    return true;
                }
            }
            if self.qcol[col].air == 0 && self.qcol[col].water > 0 {
                // fill that entire column with water
                println!("FILL COLUMN {col} WITH WATER");
                let mut filled = false;
                for row in 0..self.size() {
                    filled |= self.to_water_smart(row, col);
                }
                if filled {
                    return true;
                }
            }
        }
        false
    }

    pub fn debug(&self) {
        println!("cols: {:?}", self.qcol);
        println!("rows: {:?}", self.qrow);
        for line in &self.cells {
            println!("{:?}", line);
        }
    }
}

pub fn run() {
    // let cols = vec![4, 4, 5, 4, 3, 1];
    // let rows = vec![3, 4, 4, 5, 1, 4];
    // let groups = vec![
    //     //   4, 4, 5, 4, 3, 1
    //     vec![1, 1, 1, 2, 3, 3], // 3
    //     vec![1, 1, 1, 2, 3, 3], // 4
    //     vec![1, 4, 4, 2, 3, 3], // 4
    //     vec![1, 5, 5, 5, 5, 3], // 5
    //     vec![6, 6, 6, 6, 5, 3], // 1
    //     vec![6, 6, 5, 5, 5, 3], // 4
    // ];

    // slower test case
    let cols = vec![5, 4, 2, 1, 3, 5];
    let rows = vec![1, 5, 3, 4, 3, 4];
    #[rustfmt::skip]
    let groups = vec![
        //    5,  4 , 2,  1,  3,  5
        vec![ 1,  1,  2,  3,  3,  4], // 1
        vec![ 5,  5,  2,  6,  6,  4], // 5
        vec![ 7,  8,  9,  9, 10, 10], // 3
        vec![11,  8, 12, 12, 13, 13], // 4
        vec![11, 14, 14, 12, 12, 15], // 3
        vec![16, 16, 17, 18, 18, 15], // 4
    ];

    let mut coords = vec![];
    let pieces = builder::pieces(6, &groups, &mut coords);
    let mut grid = Grid2::new(&cols, &rows, pieces, &groups);

    let mut x = true;
    grid.debug();

    while x {
        println!("-----------------------------------");
        x = false;
        x |= grid.column_forcing_move();
        if x {
            grid.debug();
            continue;
        }
        x |= grid.row_forcing_move();
        grid.debug();
    }
    grid.debug();
}
