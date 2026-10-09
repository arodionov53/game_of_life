# Game of Life

Conway's Game of Life as a terminal UI application, built with Elixir and [Ratatouille](https://github.com/ndreynolds/ratatouille).

## Getting Started

### Prerequisites

- Elixir 1.14+
- Erlang/OTP 25+

### Install dependencies

```bash
mix deps.get
```

### Run with default pattern (Glider)

```bash
mix game_of_life
```

### Run with a bundled pattern

```bash
mix game_of_life priv/patterns/gosper_glider_gun.rle
```

### Available patterns

| Pattern            | File                                  |
|--------------------|---------------------------------------|
| Blinker            | `priv/patterns/blinker.rle`           |
| Toad               | `priv/patterns/toad.rle`              |
| Beacon             | `priv/patterns/beacon.rle`            |
| Pulsar             | `priv/patterns/pulsar.rle`            |
| Glider             | `priv/patterns/glider.rle` (default)  |
| Gosper Glider Gun  | `priv/patterns/gosper_glider_gun.rle` |

You can also load any custom pattern in [RLE format](https://conwaylife.com/wiki/Run_Length_Encoded):

```bash
mix game_of_life path/to/your_pattern.rle
```
