# Proposal

## Why

The project needs a working application. The goal is to build Conway's Game of Life as a terminal application in Elixir, using Ratatouille for the TUI and supporting the RLE pattern format so users can load patterns from the vast LifeWiki library.

## What Changes

- Create a new Elixir/Mix project with Ratatouille as the TUI framework
- Implement the Game of Life simulation engine (birth/death rules, generation ticking)
- Build an RLE parser to load `.rle` pattern files
- Bundle a set of classic patterns (glider, blinker, pulsar, Gosper glider gun, etc.)
- Provide interactive controls: pause/resume, step, speed adjustment, pattern loading, quit
- Render a fixed viewport centered on the initial pattern with a status bar showing generation count, alive cell count, and simulation speed

## Capabilities

### New Capabilities
- `simulation-engine`: Core Game of Life tick logic — neighbor counting, birth/death rules, generation advancement over an unbounded sparse grid
- `rle-parser`: Parsing of RLE-format pattern files into internal cell representations, including header metadata and run-length encoded cell data
- `terminal-ui`: Ratatouille-based terminal interface — grid rendering within a fixed viewport, status bar, keyboard input handling, pattern loading menu, and simulation controls

### Modified Capabilities

_None — greenfield project._

## Impact

- **Dependencies**: Elixir/Mix project with `ratatouille` (and its transitive dep `ex_termbox`) as the primary dependency
- **Code**: Three new modules — `GameOfLife.Engine`, `GameOfLife.RLE`, `GameOfLife.UI` — plus bundled `.rle` pattern files in `priv/patterns/`
- **Systems**: Terminal-only, no network or external services
