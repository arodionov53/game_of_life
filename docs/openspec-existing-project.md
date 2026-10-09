# OpenSpec for Existing Projects

Adding OpenSpec to a project that already has code. The goal: capture what exists as specs, then use the workflow for all future changes.

## Step 1 — Understand the Codebase

Before writing specs, map what you have:

```
/graphify .
```

This builds a knowledge graph — communities, god nodes, dependencies. Use it to identify the key modules worth specifying.

```
/graphify query "What are the main modules and how do they connect?"
```

## Step 2 — Initialize OpenSpec

```
/openspec propose
> "Initialize specs for the existing codebase"
```

OpenSpec reads your code and generates:

```
openspec/
├── config.yaml
├── specs/                # one dir per module discovered
│   ├── auth/
│   │   └── spec.md       # describes current behavior, not aspirational
│   ├── api/
│   │   └── spec.md
│   └── database/
│       └── spec.md
└── changes/
    └── archive/
```

**Key point:** initial specs describe what the code *does now*, not what you wish it did. Aspirational changes come later as proposals.

## Step 3 — Start Making Changes

Now use the normal workflow for any new work:

### Example: Adding Caching to an Existing API

**Explore the idea:**
```
/openspec explore
> "The API is slow on repeated queries. Should I add Redis caching
   or in-memory caching? What endpoints benefit most?"
```

Discussion mode — clarifies scope, surfaces trade-offs.

**Propose the change:**
```
/openspec propose
> "Add in-memory caching to the /products and /search endpoints
   with 5-minute TTL and cache invalidation on writes"
```

Generates:

```
openspec/changes/add-api-caching/
├── proposal.md           # what and why
├── design.md             # cache strategy, invalidation logic
├── delta-specs/          # only the specs that change
│   └── api/
│       └── spec.md       # adds caching section to existing API spec
└── tasks.md              # implementation steps
```

Delta-specs contain only the diff — what this change adds or modifies.

**Implement:**
```
/openspec apply
```

**Finish up:**
```
/openspec sync        # merge caching details into main api/spec.md
/openspec archive     # archive the completed change
```

## Example: Refactoring Existing Code

**Propose:**
```
/openspec propose
> "Extract the validation logic from controllers into a shared
   Validators module to reduce duplication"
```

OpenSpec knows the current specs, so the delta-specs show exactly what moves where.

**Implement and close:**
```
/openspec apply
/openspec sync
/openspec archive
```

Specs now reflect the new structure. Future changes build on this.

## Tips for Existing Projects

- **Don't spec everything at once** — start with the modules you're about to change. Add specs for other modules as you touch them.
- **`config.yaml` is for constraints the AI can't see** — e.g. "never break the public API", "all changes need migration scripts", "deploy target is Kubernetes".
- **Review generated specs** — the AI reads your code but may miss business context. Edit `spec.md` files directly if needed.
- **Graphify + query before proposing** — `/graphify query "What depends on the auth module?"` reveals blast radius before you write a proposal.
- **One change at a time** — finish, sync, and archive before starting the next.
