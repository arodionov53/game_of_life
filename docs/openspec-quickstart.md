# OpenSpec Quickstart

OpenSpec is a spec-driven workflow for planning and implementing changes with AI agents. It keeps your specs, designs, and tasks in version control alongside your code.

## Setup

Initialize OpenSpec in any project:

```
/openspec propose
```

This creates the `openspec/` directory with:

```
openspec/
├── config.yaml          # project settings
├── specs/               # living specifications (one dir per module)
│   ├── auth/
│   │   └── spec.md
│   └── api/
│       └── spec.md
└── changes/             # planned and archived changes
    └── archive/
```

## Core Commands

| Command | What it does |
|---|---|
| `/openspec explore` | Think through an idea before committing to it |
| `/openspec propose` | Create a change with design, specs, and tasks |
| `/openspec apply` | Implement tasks from a change |
| `/openspec sync` | Update main specs with delta changes |
| `/openspec archive` | Archive a completed change |

## Workflow

### 1. Explore (optional)

```
/openspec explore
```

> "I want to add user authentication — should I use JWT or sessions?"

Thinking partner mode. No artifacts created — just discussion to clarify requirements.

### 2. Propose

```
/openspec propose
```

> "Add a REST API with CRUD endpoints for tasks"

Generates all artifacts at once:

```
openspec/changes/add-task-api/
├── proposal.md          # what and why
├── design.md            # how — architecture decisions
├── delta-specs/         # spec changes this feature introduces
│   └── api/
│       └── spec.md
└── tasks.md             # implementation steps
```

### 3. Apply

```
/openspec apply
```

Walks through tasks one by one — writes code, runs tests, marks tasks done.

### 4. Sync & Archive

```
/openspec sync       # merge delta specs into main specs
/openspec archive    # move completed change to archive
```

## Example: New Elixir Project

Starting a Game of Life project from scratch:

**Step 1 — Propose the simulation engine:**
```
/openspec propose
> "Build a Game of Life simulation engine with RLE pattern parsing,
   grid simulation with configurable rules, and a terminal UI"
```

This creates specs for each module:

```
openspec/specs/
├── rle-parser/spec.md
├── simulation-engine/spec.md
└── terminal-ui/spec.md
```

**Step 2 — Implement:**
```
/openspec apply
```

Agent works through tasks: parser → engine → UI, writing code and tests.

**Step 3 — Next feature:**
```
/openspec propose
> "Add pattern library with preset shapes (glider, blinker, pulsar)"
```

New change builds on existing specs. Rinse and repeat.

## Tips

- **Specs are living documents** — they evolve with each change via delta-specs.
- **One change at a time** — finish and archive before starting the next.
- **`config.yaml`** — add project constraints the AI can't infer from code (e.g. "support Windows and macOS", "write docs in Spanish").
- **Combine with graphify** — run `/graphify .` first to understand the codebase, then propose changes informed by the knowledge graph. See [openspec-and-graphify.md](openspec-and-graphify.md).
