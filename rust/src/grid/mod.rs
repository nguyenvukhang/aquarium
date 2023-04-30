pub mod builder;
mod freq;
mod mutate;

use crate::cell::Cell;
use crate::piece::Piece;
use crate::quota::Quota;

pub struct Grid<'a> {
    pieces: Vec<Piece>,
    qcol: Vec<Quota>,
    qrow: Vec<Quota>,
    row_pieces: Vec<Vec<(u8, usize)>>,
    cells: Vec<Vec<Cell>>,
    groups: &'a Vec<Vec<u8>>,
}

impl<'a> Grid<'a> {
    pub fn new(
        cols: &Vec<i32>,
        rows: &Vec<i32>,
        groups: &'a Vec<Vec<u8>>,
    ) -> Self {
        let size = cols.len();
        let qcol = cols.iter().map(|v| Quota::new(*v, size)).collect();
        let qrow = rows.iter().map(|v| Quota::new(*v, size)).collect();

        let pieces = builder::pieces(size, groups);
        let row_pieces = builder::row_pieces(groups);
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

    // returns true on successful solve
    pub fn solve(&mut self) -> bool {
        let mut delta = true;
        while delta {
            delta = false;
            delta |= self.column_forcing_move();
            if delta {
                continue;
            }
            delta |= self.row_forcing_move();
        }
        self.is_solved()
    }

    fn is_solved(&self) -> bool {
        self.qcol.iter().all(|v| v.is_solved())
            && self.qrow.iter().all(|v| v.is_solved())
    }
}
