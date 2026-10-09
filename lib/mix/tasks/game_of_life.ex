defmodule Mix.Tasks.GameOfLife do
  @moduledoc """
  Launches the Game of Life terminal application.

  ## Usage

      mix game_of_life                        # start with default pattern (Glider)
      mix game_of_life path/to/pattern.rle    # start with a custom .rle file
  """

  use Mix.Task

  @shortdoc "Launch the Game of Life TUI"

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")
    GameOfLife.CLI.main(args)
  end
end
