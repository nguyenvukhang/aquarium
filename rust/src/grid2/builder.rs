use crate::{cell::Cell, piece::Piece};

type Grid<T> = Vec<Vec<T>>;
type Freq = Grid<(u8, usize)>;

fn max_g(grps: &Grid<u8>) -> u8 {
    *grps.iter().flat_map(|r| r.iter().max()).max().unwrap_or(&0)
}

pub fn row_pieces(size: usize, grps: &Grid<u8>) -> Freq {
    let max_g = max_g(grps);
    let rows = grps.iter().map(|row| {
        let mut f = vec![0; max_g as usize + 1];
        row.iter().for_each(|g| f[*g as usize] += 1);
        (0..max_g + 1)
            .filter(|i| f[*i as usize] > 0)
            .map(|i| (i, f[i as usize]))
            .collect()
    });

    rows.collect()
}

pub fn pieces<'a>(
    size: usize,
    groups: &'a Grid<u8>,
    coords: &'a mut Vec<Grid<usize>>,
) -> Vec<Piece<'a>> {
    // maximum group number
    let max_g = max_g(groups);

    // clear coordinate source
    coords.clear();
    (0..max_g as usize + 1).for_each(|_| coords.push(vec![vec![]; size]));

    // populate coordinate source
    for (r, c) in (0..size).flat_map(|r| (0..size).map(move |c| (r, c))) {
        coords[groups[r][c] as usize][r].push(c);
    }

    // build pieces by referencing coords
    (0..max_g + 1).map(|i| Piece::new(i, &coords[i as usize])).collect()
}