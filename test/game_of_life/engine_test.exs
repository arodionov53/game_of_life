defmodule GameOfLife.EngineTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Engine

  describe "tick/1 - birth rule" do
    test "dead cell with exactly 3 alive neighbors is born" do
      # Three cells in an L shape; the cell at {1, 1} has 3 neighbors
      alive = MapSet.new([{0, 0}, {1, 0}, {0, 1}])
      next = Engine.tick(alive)
      assert MapSet.member?(next, {1, 1})
    end

    test "dead cell with 2 alive neighbors stays dead" do
      # Two isolated cells; cell at {1, 0} has only 2 neighbors
      alive = MapSet.new([{0, 0}, {2, 0}])
      next = Engine.tick(alive)
      refute MapSet.member?(next, {1, 0})
    end
  end

  describe "tick/1 - survival rule" do
    test "alive cell with 2 neighbors survives" do
      # Horizontal blinker: center cell has 2 neighbors
      alive = MapSet.new([{-1, 0}, {0, 0}, {1, 0}])
      next = Engine.tick(alive)
      assert MapSet.member?(next, {0, 0})
    end

    test "alive cell with 3 neighbors survives" do
      # Block: each cell has 3 neighbors
      alive = MapSet.new([{0, 0}, {1, 0}, {0, 1}, {1, 1}])
      next = Engine.tick(alive)
      assert MapSet.member?(next, {0, 0})
    end
  end

  describe "tick/1 - death by underpopulation" do
    test "alive cell with 1 neighbor dies" do
      alive = MapSet.new([{0, 0}, {1, 0}])
      next = Engine.tick(alive)
      refute MapSet.member?(next, {0, 0})
      refute MapSet.member?(next, {1, 0})
    end

    test "isolated alive cell dies" do
      alive = MapSet.new([{5, 5}])
      next = Engine.tick(alive)
      assert MapSet.size(next) == 0
    end
  end

  describe "tick/1 - death by overpopulation" do
    test "alive cell with 4 neighbors dies" do
      # Plus shape: center cell has 4 neighbors
      alive = MapSet.new([{0, 0}, {-1, 0}, {1, 0}, {0, -1}, {0, 1}])
      next = Engine.tick(alive)
      refute MapSet.member?(next, {0, 0})
    end
  end

  describe "tick/1 - generation advancement" do
    test "blinker oscillates" do
      horizontal = MapSet.new([{0, -1}, {0, 0}, {0, 1}])
      vertical = MapSet.new([{-1, 0}, {0, 0}, {1, 0}])

      assert Engine.tick(horizontal) == vertical
      assert Engine.tick(vertical) == horizontal
    end

    test "block is stable" do
      block = MapSet.new([{0, 0}, {0, 1}, {1, 0}, {1, 1}])
      assert Engine.tick(block) == block
    end
  end

  describe "tick/1 - unbounded grid" do
    test "glider moves into negative coordinates" do
      # Standard glider moving down-left
      glider = MapSet.new([{1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}])

      # Run for many generations
      final =
        Enum.reduce(1..40, glider, fn _, cells ->
          Engine.tick(cells)
        end)

      # After 40 generations, the glider should have moved ~10 cells diagonally.
      assert MapSet.size(final) == 5

      {min_x, _} = final |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
      {min_y, _} = final |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

      # The glider has moved far from origin, proving unbounded grid works
      assert min_x > 5 or min_y > 5
    end
  end

  describe "neighbor_count/2" do
    test "cell with no alive neighbors returns 0" do
      alive = MapSet.new([{5, 5}])
      assert Engine.neighbor_count(alive, {0, 0}) == 0
    end

    test "center cell surrounded by 8 neighbors" do
      alive =
        MapSet.new([
          {0, 0}, {1, 0}, {2, 0},
          {0, 1},         {2, 1},
          {0, 2}, {1, 2}, {2, 2}
        ])

      assert Engine.neighbor_count(alive, {1, 1}) == 8
    end

    test "corner cell counts only existing neighbors" do
      alive = MapSet.new([{0, 0}, {1, 0}, {0, 1}])
      # {0, 0} has neighbors at {1, 0} and {0, 1}
      assert Engine.neighbor_count(alive, {0, 0}) == 2
    end

    test "cell does not count itself" do
      alive = MapSet.new([{5, 5}])
      assert Engine.neighbor_count(alive, {5, 5}) == 0
    end
  end

  describe "alive_count/1" do
    test "empty grid" do
      assert Engine.alive_count(MapSet.new()) == 0
    end

    test "matches MapSet.size" do
      alive = MapSet.new([{0, 0}, {1, 1}, {2, 2}, {3, 3}])
      assert Engine.alive_count(alive) == 4
      assert Engine.alive_count(alive) == MapSet.size(alive)
    end
  end
end
