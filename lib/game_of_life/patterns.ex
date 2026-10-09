defmodule GameOfLife.Patterns do
  @moduledoc """
  Provides access to bundled Game of Life patterns stored as `.rle` files
  in `priv/patterns/`.
  """

  @doc """
  Lists all bundled patterns with their names and file paths.

  Returns a list of `%{name: String.t(), file: String.t()}` sorted by name.
  The name is extracted from the `#N` comment in each `.rle` file.
  """
  @spec list() :: [%{name: String.t(), file: String.t()}]
  def list do
    patterns_dir()
    |> Path.join("*.rle")
    |> Path.wildcard()
    |> Enum.map(fn path ->
      name =
        case GameOfLife.RLE.parse_file(path) do
          {:ok, %{metadata: %{name: n}}} -> n
          _ -> path |> Path.basename(".rle") |> String.replace("_", " ")
        end

      %{name: name, file: path}
    end)
    |> Enum.sort_by(& &1.name)
  end

  @doc """
  Loads a pattern by name, returning its alive cells as a MapSet.

  Returns `{:ok, MapSet.t()}` or `{:error, :not_found}`.
  """
  @spec load(String.t()) :: {:ok, MapSet.t()} | {:error, :not_found}
  def load(name) do
    case Enum.find(list(), fn p -> p.name == name end) do
      nil ->
        {:error, :not_found}

      %{file: path} ->
        case GameOfLife.RLE.parse_file(path) do
          {:ok, %{cells: cells}} -> {:ok, cells}
          {:error, _} -> {:error, :not_found}
        end
    end
  end

  defp patterns_dir do
    :game_of_life
    |> :code.priv_dir()
    |> to_string()
    |> Path.join("patterns")
  end
end
