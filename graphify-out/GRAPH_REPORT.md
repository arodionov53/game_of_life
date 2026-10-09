# Graph Report - my-tic-tac-toe  (2026-10-07)

## Corpus Check
- Corpus is ~35,397 words - fits in a single context window. You may not need a graph.

## Summary
- 107 nodes · 119 edges · 17 communities (9 shown, 8 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 8 edges (avg confidence: 0.92)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Game of Life Design
- OpenSpec Workflow
- Spec Sync & Archive
- Simulation Engine
- Terminal UI App
- Test Suite
- Pattern Library
- RLE Parser
- Mix Project Config
- Mix Tasks
- Core Module
- OTP Application
- CLI Entry Point
- Change Metadata
- OpenSpec Config

## God Nodes (most connected - your core abstractions)
1. `Terminal UI (GameOfLife.UI.App)` - 9 edges
2. `GameOfLife.UI.App` - 8 edges
3. `GameOfLife.RLE` - 7 edges
4. `OPSX: Apply Command` - 7 edges
5. `OPSX: Propose Command` - 7 edges
6. `RLE Parser (GameOfLife.RLE)` - 7 edges
7. `GameOfLife.Engine` - 6 edges
8. `GameOfLife.Patterns` - 6 edges
9. `Simulation Engine (GameOfLife.Engine)` - 6 edges
10. `parse_string()` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Game of Life Project README` --references--> `Conway's Game of Life`  [EXTRACTED]
  README.md → openspec/changes/archive/2026-10-06-conways-game-of-life/proposal.md
- `Conway's Game of Life Tasks` --implements--> `Conway's Game of Life Design`  [INFERRED]
  openspec/changes/archive/2026-10-06-conways-game-of-life/tasks.md → openspec/changes/archive/2026-10-06-conways-game-of-life/design.md
- `RLE Parser Specification` --semantically_similar_to--> `RLE Parser Spec Delta (Archive)`  [INFERRED] [semantically similar]
  openspec/specs/rle-parser/spec.md → openspec/changes/archive/2026-10-06-conways-game-of-life/specs/rle-parser/spec.md
- `Simulation Engine Specification` --semantically_similar_to--> `Simulation Engine Spec Delta (Archive)`  [INFERRED] [semantically similar]
  openspec/specs/simulation-engine/spec.md → openspec/changes/archive/2026-10-06-conways-game-of-life/specs/simulation-engine/spec.md
- `Terminal UI Specification` --semantically_similar_to--> `Terminal UI Spec Delta (Archive)`  [INFERRED] [semantically similar]
  openspec/specs/terminal-ui/spec.md → openspec/changes/archive/2026-10-06-conways-game-of-life/specs/terminal-ui/spec.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **OpenSpec Change Lifecycle** — _claude_commands_opsx_explore_opsx_explore, _claude_commands_opsx_propose_opsx_propose, _claude_commands_opsx_apply_opsx_apply, _claude_commands_opsx_update_opsx_update, _claude_commands_opsx_sync_opsx_sync, _claude_commands_opsx_archive_opsx_archive [EXTRACTED 1.00]
- **Command-Skill Implementation Pairs** — _claude_commands_opsx_apply_opsx_apply, _claude_commands_opsx_archive_opsx_archive, _claude_commands_opsx_explore_opsx_explore, _claude_commands_opsx_propose_opsx_propose, _claude_commands_opsx_sync_opsx_sync, _claude_commands_opsx_update_opsx_update, _claude_skills_openspec_apply_change_skill_openspec_apply_change, _claude_skills_openspec_archive_change_skill_openspec_archive_change, _claude_skills_openspec_explore_skill_openspec_explore, _claude_skills_openspec_propose_skill_openspec_propose, _claude_skills_openspec_sync_specs_skill_openspec_sync_specs, _claude_skills_openspec_update_change_skill_openspec_update_change [EXTRACTED 1.00]
- **Delta-to-Main Spec Sync Flow** — delta_spec, main_spec, intelligent_merging, _claude_commands_opsx_sync_opsx_sync [EXTRACTED 1.00]
- **Game of Life Three-Capability Architecture** — concept_simulation_engine, concept_rle_parser, concept_terminal_ui [EXTRACTED 1.00]
- **OpenSpec Change Artifact Set (Proposal/Design/Tasks/Specs)** — openspec_changes_archive_2026_10_06_conways_game_of_life_proposal_conways_game_of_life, openspec_changes_archive_2026_10_06_conways_game_of_life_design_architecture, openspec_changes_archive_2026_10_06_conways_game_of_life_tasks_implementation, openspec_changes_archive_2026_10_06_conways_game_of_life_specs_rle_parser_spec, openspec_changes_archive_2026_10_06_conways_game_of_life_specs_simulation_engine_spec, openspec_changes_archive_2026_10_06_conways_game_of_life_specs_terminal_ui_spec [EXTRACTED 1.00]
- **Data Flow: RLE Parser -> Patterns -> Engine -> UI** — concept_rle_parser, concept_patterns_module, concept_simulation_engine, concept_terminal_ui [INFERRED 0.95]

## Communities (17 total, 8 thin omitted)

### Community 0 - "Game of Life Design"
Cohesion: 0.11
Nodes (17): Conway's Game of Life, Moore Neighborhood, GameOfLife.Patterns Module, Run Length Encoding (RLE) Format, RLE Parser (GameOfLife.RLE), Simulation Engine (GameOfLife.Engine), Terminal UI (GameOfLife.UI.App), Conway's Game of Life Design (+9 more)

### Community 1 - "OpenSpec Workflow"
Cohesion: 0.19
Nodes (11): OPSX: Apply Command, OPSX: Explore Command, OPSX: Propose Command, OpenSpec Apply Change Skill, OpenSpec Explore Skill, OpenSpec Propose Skill, OpenSpec Artifact, OpenSpec Change (+3 more)

### Community 2 - "Spec Sync & Archive"
Cohesion: 0.28
Nodes (8): OPSX: Archive Command, OPSX: Sync Command, OPSX: Update Command, OpenSpec Archive Change Skill, OpenSpec Sync Specs Skill, OpenSpec Update Change Skill, Delta Spec, Main Spec

### Community 3 - "Simulation Engine"
Cohesion: 0.25
Nodes (3): GameOfLife.Engine, neighbor_count(), tick()

### Community 4 - "Terminal UI App"
Cohesion: 0.39
Nodes (6): GameOfLife.UI.App, center_viewport(), init(), load_initial_pattern(), select_pattern(), update()

### Community 5 - "Test Suite"
Cohesion: 0.29
Nodes (3): GameOfLife.EngineTest, GameOfLife.RLETest, GameOfLifeTest

### Community 6 - "Pattern Library"
Cohesion: 0.33
Nodes (4): GameOfLife.Patterns, list(), patterns_dir(), GameOfLife.PatternsTest

### Community 7 - "RLE Parser"
Cohesion: 0.48
Nodes (6): GameOfLife.RLE, decode_cells(), parse_comments(), parse_file(), parse_header(), parse_string()

### Community 8 - "Mix Project Config"
Cohesion: 0.40
Nodes (3): GameOfLife.MixProject, deps(), project()

## Knowledge Gaps
- **19 isolated node(s):** `GameOfLife.EngineTest`, `GameOfLife.PatternsTest`, `GameOfLife.RLETest`, `GameOfLifeTest`, `OpenSpec Apply Change Skill` (+14 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 50 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `GameOfLife.Engine` connect `Simulation Engine` to `Test Suite`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **What connects `GameOfLife.EngineTest`, `GameOfLife.PatternsTest`, `GameOfLife.RLETest` to the rest of the system?**
  _19 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Game of Life Design` be split into smaller, more focused modules?**
  _Cohesion score 0.10507246376811594 - nodes in this community are weakly interconnected._
- **Why does `GameOfLife.Patterns` connect `Pattern Library` to `Simulation Engine`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Why does `GameOfLife.UI.App` connect `Terminal UI App` to `Simulation Engine`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._