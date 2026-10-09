# terminal-ui Specification

## Purpose

Provides the interactive terminal interface for viewing and controlling the Game of Life simulation using Ratatouille.

## Requirements

### Requirement: Grid rendering
The UI SHALL render alive cells as filled characters and dead cells as empty space within the terminal viewport.

#### Scenario: Alive cells are visible
- **WHEN** the simulation contains alive cells within the viewport
- **THEN** those cells are rendered as visible characters at the corresponding viewport positions

#### Scenario: Dead cells are blank
- **WHEN** a cell within the viewport is dead
- **THEN** that position is rendered as empty space

### Requirement: Fixed viewport
The UI SHALL display a fixed viewport sized to the terminal dimensions, centered on the initial pattern.

#### Scenario: Pattern is centered on load
- **WHEN** a pattern is loaded
- **THEN** the viewport is centered on the bounding box of the pattern's cells

#### Scenario: Cells outside viewport still simulated
- **WHEN** alive cells move beyond the viewport boundaries
- **THEN** the simulation continues to track them but they are not rendered

### Requirement: Status bar
The UI SHALL display a status bar showing the current generation number, count of alive cells, and simulation speed.

#### Scenario: Status bar content
- **WHEN** the simulation is at generation 42 with 137 alive cells running at 10 generations per second
- **THEN** the status bar displays generation 42, 137 alive cells, and speed 10/s

### Requirement: Pause and resume
The user SHALL be able to pause and resume the simulation with the space key.

#### Scenario: Pause running simulation
- **WHEN** the simulation is running and the user presses space
- **THEN** the simulation stops advancing generations

#### Scenario: Resume paused simulation
- **WHEN** the simulation is paused and the user presses space
- **THEN** the simulation resumes advancing generations

### Requirement: Step forward
The user SHALL be able to advance exactly one generation while paused by pressing the `n` key.

#### Scenario: Single step while paused
- **WHEN** the simulation is paused and the user presses `n`
- **THEN** the simulation advances by exactly one generation and remains paused

### Requirement: Speed adjustment
The user SHALL be able to increase and decrease the simulation speed with `+` and `-` keys.

#### Scenario: Increase speed
- **WHEN** the user presses `+`
- **THEN** the simulation speed increases

#### Scenario: Decrease speed
- **WHEN** the user presses `-`
- **THEN** the simulation speed decreases

#### Scenario: Speed does not go below minimum
- **WHEN** the simulation is at minimum speed and the user presses `-`
- **THEN** the speed remains at the minimum

### Requirement: Quit
The user SHALL be able to exit the application by pressing `q`.

#### Scenario: Quit application
- **WHEN** the user presses `q`
- **THEN** the application exits and the terminal is restored to its previous state

### Requirement: Pattern loading
The user SHALL be able to load a pattern from the bundled set or a file path.

#### Scenario: Load bundled pattern
- **WHEN** the user opens the pattern menu and selects a bundled pattern
- **THEN** the simulation resets to generation 0 with the selected pattern, centered in the viewport

#### Scenario: Bundled pattern list
- **WHEN** the user opens the pattern menu
- **THEN** the menu lists all bundled patterns by name

### Requirement: Bundled classic patterns
The application SHALL include at least the following bundled patterns: glider, blinker, toad, beacon, pulsar, and Gosper glider gun.

#### Scenario: All required patterns present
- **WHEN** the application starts
- **THEN** the bundled pattern set includes glider, blinker, toad, beacon, pulsar, and Gosper glider gun
