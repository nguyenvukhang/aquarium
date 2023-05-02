## Aquarium Engine

To run tests, run `cargo test`.

To build, run `cargo build` (use `cargo build --release` to make full
use of rustc's compile-time optimizations)

Build output goes to `./target/debug/aquarium` (or
`./target/release/aquarium`), and is meant to be ran with the problem
id as the first argument:

```
$ ./target/release/aquarium MToyLDE5NiwwNjk=
Successful solve!
Grid {
         [0,0, 0,0, 0,0, 0,0, 0,0, 0,0]
         ┌───────────────┬───────┐
     0,0 │ ■   ■   ■   ■ │ ×   × │
         ├───┬───┬───────┘   ┌───┤
     0,0 │ × │ × │ ×   ×   × │ ■ │
         │   │   └───┐   ┌───┘   │
     0,0 │ × │ ■   ■ │ × │ ■   ■ │
         ├───┘   ┌───┤   │       │
     0,0 │ ■   ■ │ × │ × │ ■   ■ │
         ├───┬───┘   │   ├───────┤
     0,0 │ × │ ■   ■ │ × │ ■   ■ │
         │   └───────┴───┼───────┤
     0,0 │ ×   ×   ×   × │ ■   ■ │
         └───────────────┴───────┘
}
aquarium-rust: done execution!
```

### Current issues

Immediate areas for improvement:

1. This algorithm is (so far) 100% analytical. It only makes moves
   that are immediately forced. There is no look-ahead, no
   back-tracking.
2. Analysis of column-pouring can be improved. Currently, column
   scanning is only limited to zero-water or zero-air columns.
