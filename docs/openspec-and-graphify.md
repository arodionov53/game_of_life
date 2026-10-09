# Combining OpenSpec and graphify

## What Each Does

| | **OpenSpec** | **graphify** |
|---|---|---|
| **Purpose** | Plan & track changes (specs, tasks, design) | Map & explore the codebase (knowledge graph) |
| **Output** | `openspec/` — specs, changes, tasks | `graphify-out/` — graph.json, report, HTML viz |
| **Strength** | *Where are we going?* | *Where are we now?* |

## The Workflow

### 1. Start with graphify to understand the codebase

```
/graphify .
```

Builds a knowledge graph — god nodes, communities, surprising connections. This gives you (and the AI) a structural map before you plan anything.

### 2. Use graphify queries to inform OpenSpec proposals

```
/graphify query "What modules would be affected by adding multiplayer support?"
```

The graph traces dependencies across communities, so you know the blast radius *before* writing a change proposal.

### 3. Propose with OpenSpec, informed by the graph

```
/openspec propose
```

Now your proposal is grounded in actual architecture, not guesses.

### 4. After implementing, rebuild the graph

```
/graphify . --update
```

Incremental update — only re-extracts changed files. The graph now reflects the new code.

### 5. Query the updated graph to verify structure

```
/graphify query "How does the new module connect to the rest?"
```

## Practical Tips

- **Run graphify first** on any unfamiliar codebase before proposing changes — the community structure and god nodes reveal where complexity lives.
- **Use `--update` after each OpenSpec change** is implemented — keeps the graph current without a full rebuild.
- **Query before proposing** — `/graphify query` can answer "what depends on X?" or "what's the shortest path between A and B?" which directly informs your design decisions.
- **The graph report's Suggested Questions** often surface architectural concerns that should appear in your OpenSpec design doc.
