defmodule GameOfLife.PatternsTest do
  use ExUnit.Case, async: true

  alias GameOfLife.Patterns

  @required_patterns [
    "Beacon",
    "Blinker",
    "Glider",
    "Gosper glider gun",
    "Pulsar",
    "Toad"
  ]

  describe "list/0" do
    test "returns all six required patterns" do
      names = Patterns.list() |> Enum.map(& &1.name)

      for pattern <- @required_patterns do
        assert pattern in names, "Missing required pattern: #{pattern}"
      end
    end

    test "each entry has name and file" do
      for pattern <- Patterns.list() do
        assert is_binary(pattern.name)
        assert is_binary(pattern.file)
        assert String.ends_with?(pattern.file, ".rle")
      end
    end
  end

  describe "load/1" do
    test "returns non-empty MapSet for each required pattern" do
      for name <- @required_patterns do
        assert {:ok, cells} = Patterns.load(name), "Failed to load: #{name}"
        assert MapSet.size(cells) > 0, "Empty cells for: #{name}"
      end
    end

    test "returns error for unknown pattern" do
      assert {:error, :not_found} = Patterns.load("nonexistent")
    end
  end
end
