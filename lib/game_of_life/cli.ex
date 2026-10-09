defmodule GameOfLife.CLI do
  @moduledoc """
  Entry point for the Game of Life application.

  ## Usage

      mix game_of_life                    # start with default pattern (Glider)
      mix game_of_life path/to/pattern.rle  # start with a custom .rle file
  """

  def main(args \\ []) do
    case args do
      [path | _] -> Application.put_env(:game_of_life, :rle_file, path)
      [] -> :ok
    end

    Ratatouille.run(GameOfLife.UI.App, interval: 50)
  end
end
