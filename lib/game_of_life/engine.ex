defmodule GameOfLife.Engine do
  @moduledoc """
  Pure-function Game of Life simulation engine.

  Operates on a MapSet of `{x, y}` tuples representing alive cells
  on an unbounded grid, applying Conway's rules each generation.
  """

  @doc """
  Computes the next generation by applying Conway's rules simultaneously
  to all cells. A dead cell with exactly 3 alive neighbors is born.
  An alive cell with 2 or 3 alive neighbors survives. All other alive
  cells die.
  """
  @spec tick(MapSet.t()) :: MapSet.t()
  def tick(alive_cells) do
    # Collect all cells that could potentially be alive next generation:
    # every alive cell and every neighbor of an alive cell.
    candidates =
      alive_cells
      |> Enum.flat_map(fn {x, y} ->
        for dx <- -1..1, dy <- -1..1 do
          {x + dx, y + dy}
        end
      end)
      |> MapSet.new()

    Enum.reduce(candidates, MapSet.new(), fn cell, acc ->
      count = neighbor_count(alive_cells, cell)
      alive? = MapSet.member?(alive_cells, cell)

      cond do
        alive? and count in [2, 3] -> MapSet.put(acc, cell)
        not alive? and count == 3 -> MapSet.put(acc, cell)
        true -> acc
      end
    end)
  end

  @doc """
  Counts the alive neighbors of a cell using the Moore neighborhood
  (8 orthogonal and diagonal adjacents).
  """
  @spec neighbor_count(MapSet.t(), {integer(), integer()}) :: non_neg_integer()
  def neighbor_count(alive_cells, {x, y}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0}, reduce: 0 do
      acc ->
        if MapSet.member?(alive_cells, {x + dx, y + dy}), do: acc + 1, else: acc
    end
  end

  @doc """
  Returns the number of alive cells.
  """
  @spec alive_count(MapSet.t()) :: non_neg_integer()
  def alive_count(alive_cells) do
    MapSet.size(alive_cells)
  end
end
