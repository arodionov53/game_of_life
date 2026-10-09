# Tasks

## 1. Project Scaffolding

- [x] 1.1 Initialize Mix project with `mix new game_of_life --sup` in the repo root, add `ratatouille` dependency to `mix.exs`, configure escript with `main_module: GameOfLife.CLI`, and run `mix deps.get`. Verify: `mix compile` succeeds with zero warnings.
- [x] 1.2 Create `lib/game_of_life/cli.ex` with a `main/1` function that prints "Game of Life" and exits. Verify: `mix escript.build && ./game_of_life` prints the message.

## 2. Simulation Engine

- [x] 2.1 Create `lib/game_of_life/engine.ex` with `GameOfLife.Engine.tick/1` that takes a `MapSet` of `{x, y}` alive cells and returns the next generation by applying Conway's rules (birth at 3 neighbors, survival at 2-3, death otherwise) using Moore neighborhood. Verify: `mix test test/game_of_life/engine_test.exs` passes tests for all spec scenarios — blinker oscillation, block stability, birth, survival, underpopulation death, overpopulation death, and glider movement into negative coordinates.
- [x] 2.2 Add `GameOfLife.Engine.neighbor_count/2` (public for testing) and `GameOfLife.Engine.alive_count/1`. Verify: unit tests confirm neighbor_count returns correct values for corner, edge, and center cells, and alive_count matches MapSet.size.

## 3. RLE Parser

- [x] 3.1 Create `lib/game_of_life/rle.ex` with `GameOfLife.RLE.parse_string/1` that parses an RLE-encoded string into `{:ok, %{cells: MapSet.t(), metadata: map()}}` or `{:error, reason}`. Handle comment lines (`#N`, `#C`, etc.), the `x = ..., y = ...` header, and the encoded cell data (`b`, `o`, `$`, `!`, run-length prefixes). Ignore whitespace in the data section. Verify: `mix test test/game_of_life/rle_test.exs` passes tests for glider (`bo$2bo$3o!`), run-length prefix (`3o!`), multi-row (`o$o$o!`), header parsing, name comment extraction, whitespace tolerance across line-wrapped data, and malformed input errors.
- [x] 3.2 Add `GameOfLife.RLE.parse_file/1` that reads a file path and delegates to `parse_string/1`. Return `{:error, :file_not_found}` for missing files. Verify: tests confirm successful file reading and proper error on missing path.

## 4. Bundled Patterns

- [x] 4.1 Add `.rle` files to `priv/patterns/` for at least: glider, blinker, toad, beacon, pulsar, and Gosper glider gun. Source from LifeWiki or encode manually. Verify: each file parses without error via `GameOfLife.RLE.parse_file/1` in a test.
- [x] 4.2 Create `lib/game_of_life/patterns.ex` with `GameOfLife.Patterns.list/0` returning `[%{name: String.t(), file: String.t()}]` of all bundled patterns, and `GameOfLife.Patterns.load/1` taking a pattern name and returning the parsed cells. Patterns are discovered from `priv/patterns/*.rle` using the `#N` comment as the display name. Verify: `Patterns.list/0` returns all six required patterns and `Patterns.load/1` returns a non-empty MapSet for each.

## 5. Terminal UI

- [x] 5.1 Create `lib/game_of_life/ui/app.ex` implementing `Ratatouille.App` behaviour with `init/1`, `update/2`, and `render/1`. The model holds: `cells` (MapSet), `generation` (integer), `speed` (integer, generations/sec), `paused` (boolean), `viewport_x`/`viewport_y` (integer offsets). `init/1` loads the default pattern (glider) via `Patterns.load/1` and centers the viewport on its bounding box. `render/1` draws alive cells as `█` within the viewport area and a status bar at the bottom showing generation, alive count, and speed. Verify: `mix compile` succeeds and launching via `Ratatouille.run(GameOfLife.UI.App)` in IEx displays the grid with the glider pattern and status bar.
- [x] 5.2 Implement simulation ticking in `update/2`: on init, schedule a `:tick` message with `Process.send_after/3` at `div(1000, speed)` ms. On `:tick`, if not paused, call `Engine.tick/1`, increment generation, and re-schedule. Verify: launching the app shows the glider animating across the grid.
- [x] 5.3 Implement keyboard controls in `update/2`: space toggles `paused`, `n` calls `Engine.tick/1` once when paused, `+`/`-` adjust speed (clamped to 1..50), `q` returns `{:quit, model}`. Verify: manually confirm each key works — pause stops animation, step advances one generation, speed changes are reflected in the status bar, and q exits cleanly.
- [x] 5.4 Implement pattern loading: `l` key opens a pattern selection overlay listing `Patterns.list/0` names with number keys (1-9) or arrow keys + enter to select. Selection resets cells, generation to 0, and re-centers viewport. Escape dismisses the menu. Verify: pressing `l` shows the menu, selecting a pattern loads it centered, escape returns to the simulation.
- [x] 5.5 Update `lib/game_of_life/cli.ex` to call `Ratatouille.run(GameOfLife.UI.App)` as the main entry point. Verify: `mix escript.build && ./game_of_life` launches the full interactive application.

## 6. Integration Verification

- [x] 6.1 Run `mix test` and confirm all tests pass. Run `mix escript.build` and verify the built binary launches, displays a pattern, responds to all keyboard controls (pause, step, speed, pattern load, quit), and exits cleanly.
