# simulation-engine Specification

## Purpose

Implements Conway's Game of Life cellular automaton rules over an unbounded sparse grid, advancing the simulation one generation at a time.

## Requirements

### Requirement: Standard birth rule
A dead cell with exactly three alive neighbors SHALL become alive in the next generation.

#### Scenario: Dead cell with three neighbors is born
- **WHEN** a dead cell has exactly 3 alive neighbors
- **THEN** it becomes alive in the next generation

#### Scenario: Dead cell with two neighbors stays dead
- **WHEN** a dead cell has exactly 2 alive neighbors
- **THEN** it remains dead in the next generation

### Requirement: Standard survival rule
An alive cell with exactly two or three alive neighbors SHALL remain alive in the next generation.

#### Scenario: Alive cell with two neighbors survives
- **WHEN** an alive cell has exactly 2 alive neighbors
- **THEN** it remains alive in the next generation

#### Scenario: Alive cell with three neighbors survives
- **WHEN** an alive cell has exactly 3 alive neighbors
- **THEN** it remains alive in the next generation

### Requirement: Death by underpopulation
An alive cell with fewer than two alive neighbors SHALL die in the next generation.

#### Scenario: Alive cell with one neighbor dies
- **WHEN** an alive cell has exactly 1 alive neighbor
- **THEN** it is dead in the next generation

#### Scenario: Isolated alive cell dies
- **WHEN** an alive cell has 0 alive neighbors
- **THEN** it is dead in the next generation

### Requirement: Death by overpopulation
An alive cell with more than three alive neighbors SHALL die in the next generation.

#### Scenario: Alive cell with four neighbors dies
- **WHEN** an alive cell has exactly 4 alive neighbors
- **THEN** it is dead in the next generation

### Requirement: Neighbor counting uses Moore neighborhood
The eight cells orthogonally and diagonally adjacent to a cell SHALL be considered its neighbors.

#### Scenario: Center cell neighbor count
- **WHEN** computing neighbors of cell at position (5, 5)
- **THEN** the cells at (4,4), (4,5), (4,6), (5,4), (5,6), (6,4), (6,5), (6,6) are considered

### Requirement: Generation advancement
The engine SHALL compute the next generation by applying birth, survival, and death rules simultaneously to all cells.

#### Scenario: Blinker oscillates
- **WHEN** the grid contains a horizontal blinker at (0,-1), (0,0), (0,1)
- **THEN** after one tick, the grid contains a vertical blinker at (-1,0), (0,0), (1,0)

#### Scenario: Block is stable
- **WHEN** the grid contains a block at (0,0), (0,1), (1,0), (1,1)
- **THEN** after one tick, the grid is unchanged

### Requirement: Unbounded grid
The simulation SHALL operate on an unbounded grid with no fixed size limit; cells at any coordinate SHALL follow the same rules.

#### Scenario: Glider moves into negative coordinates
- **WHEN** a glider is placed near the origin and ticked repeatedly
- **THEN** it moves into negative coordinate space without boundary errors
