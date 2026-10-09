# Design

## Context

This is a greenfield Elixir/Mix project. No existing code, dependencies, or infrastructure. See proposal.md for motivation.

The project builds Conway's Game of Life as an interactive terminal application. The three capabilities (simulation engine, RLE parser, terminal UI) map cleanly to three modules with minimal coupling.

## Goals / Non-Goals

**Goals:**
- Clean separation between simulation logic, file parsing, and UI
- Pure-function engine that is trivially testable without a terminal
- Correct RLE parsing compatible with LifeWiki exports
- Responsive TUI with real-time simulation and interactive controls

**Non-Goals:**
- Online multiplayer or network features
- GUI or web interface
- Editing cells by clicking/cursor (draw mode)
- Infinite history / undo
- Performance optimization for very large patterns (millions of cells)

## Decisions

### D1: Grid representation — MapSet of `{x, y}` tuples

Store only alive cells as a `MapSet.t({integer(), integer()})`.

**Why over alternatives:**
- **vs. 2D list/array**: MapSet is sparse — memory is proportional to alive cells, not grid area. An unbounded grid has no natural array bounds.
- **vs. Map with `%{{x,y} => :alive}`**: MapSet is simpler since we only need membership testing; there's no per-cell data beyond alive/dead.
- **vs. ETS table**: Overkill for single-process use; MapSet is immutable and fits Elixir idioms.

Neighbor lookup is O(1) per cell via `MapSet.member?/2`.

### D2: TUI framework — Ratatouille

Use the `ratatouille` hex package for terminal rendering.

**Why over alternatives:**
- **vs. raw ANSI escape codes**: Ratatouille provides an Elm-architecture (model/update/render) loop, event handling, and layout primitives. Raw ANSI would require reimplementing all of this.
- **vs. ExTermbox directly**: Ratatouille wraps ExTermbox with a higher-level API; using ExTermbox directly gains nothing for this use case.

Ratatouille's `update/2` callback handles keyboard events; `render/1` builds the view tree each frame. The simulation tick will be driven by `Process.send_after/3` posting a `:tick` message at the configured interval.

### D3: Module structure

```
lib/
  game_of_life/
    engine.ex          # Pure functions: tick/1, neighbors/2, alive_count/1
    rle.ex             # RLE parser: parse_string/1, parse_file/1
    patterns.ex        # Bundled patterns: list/0, load/1
    ui/
      app.ex           # Ratatouille app: init/1, update/2, render/1
```

- `GameOfLife.Engine` — stateless, pure functions. `tick(cells)` returns the next generation. No GenServer needed.
- `GameOfLife.RLE` — parses RLE strings and files into `{MapSet.t(), metadata}`.
- `GameOfLife.Patterns` — wraps bundled `.rle` files from `priv/patterns/`, provides `list/0` and `load/1`.
- `GameOfLife.UI.App` — Ratatouille application module. Holds state (cells, generation, speed, paused flag, viewport offset). Dispatches `:tick` messages for auto-advance.

### D4: Simulation timing via self-messaging

The UI process sends itself `{:tick, speed}` via `Process.send_after/3`. On each tick (when not paused), it calls `Engine.tick/1` and re-arms the timer. Speed adjustment changes the interval (e.g., 1000ms / speed).

**Why over alternatives:**
- **vs. separate GenServer**: Adds complexity with no benefit — the UI process already has a message loop via Ratatouille's `update/2`.
- **vs. `:timer.send_interval`**: `send_after` is simpler to adjust dynamically when speed changes.

### D5: Viewport calculation

On pattern load, compute the bounding box of alive cells and center the viewport on it. The viewport size is the terminal dimensions (from Ratatouille). Cells are rendered at `(cell_x - viewport_left, cell_y - viewport_top)` and clipped to bounds.

### D6: Bundled patterns as `.rle` files in `priv/patterns/`

Ship patterns as actual `.rle` files rather than hardcoded coordinate lists. This means the RLE parser is exercised on every load, and adding new patterns is just dropping a file.

### D7: Mix project as escript

Build as an escript (`mix escript.build`) for a single-binary distribution. The main entry point invokes `Ratatouille.run/2` with the app module.

## Risks / Trade-offs

- **[Ratatouille maintenance]** → The library hasn't seen frequent updates. Mitigation: it's stable, wraps ExTermbox which is mature, and the API surface we use is small. If it breaks, the abstraction boundary makes swapping feasible.
- **[Performance on large patterns]** → MapSet neighbor-counting is O(alive_cells). Patterns with >10k cells may lag at high speeds. Mitigation: acceptable for v1; a hashlife algorithm could replace `Engine.tick/1` later without changing the interface.
- **[Terminal compatibility]** → ExTermbox may behave differently across terminal emulators. Mitigation: test on common terminals (iTerm2, Terminal.app, Alacritty). Ratatouille handles most abstraction.
