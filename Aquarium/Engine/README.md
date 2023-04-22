# Aquarium Engine

For a list of commands that a developer uses to debug this package,
look into `Makefile`.

```makefile
dev:
  swift run Cli # build for debug + run ./Sources/Cli/main.swift

build:
  swift build --product Cli # build only

run:
  ./.build/debug/Cli # run only

test:
  swift run Tests # run tests at ./Tests/main.swift
```
