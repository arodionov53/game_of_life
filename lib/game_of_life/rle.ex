defmodule GameOfLife.RLE do
  @moduledoc """
  Parser for Run Length Encoded (.rle) pattern files.

  Supports comment lines (#N, #C, etc.), the x/y header,
  and RLE-encoded cell data (b=dead, o=alive, $=end row, !=end pattern).
  Whitespace in the data section is ignored.
  """

  @doc """
  Parses an RLE-encoded string into cells and metadata.

  Returns `{:ok, %{cells: MapSet.t(), metadata: map()}}` or `{:error, reason}`.
  """
  @spec parse_string(String.t()) :: {:ok, %{cells: MapSet.t(), metadata: map()}} | {:error, term()}
  def parse_string(input) do
    lines = String.split(input, ~r/\r?\n/)
    {comments, rest} = Enum.split_while(lines, &String.starts_with?(&1, "#"))

    metadata = parse_comments(comments)

    case rest do
      [] ->
        {:error, "missing header and cell data"}

      [header_line | data_lines] ->
        case parse_header(header_line) do
          {:ok, header_meta} ->
            merged_metadata = Map.merge(metadata, header_meta)
            data = data_lines |> Enum.join() |> String.replace(~r/\s/, "")

            case decode_cells(data) do
              {:ok, cells} ->
                {:ok, %{cells: cells, metadata: merged_metadata}}

              {:error, _} = err ->
                err
            end

          {:error, _} = err ->
            err
        end
    end
  end

  @doc """
  Reads and parses an RLE file from disk.

  Returns `{:ok, %{cells: MapSet.t(), metadata: map()}}` or `{:error, reason}`.
  """
  @spec parse_file(String.t()) :: {:ok, %{cells: MapSet.t(), metadata: map()}} | {:error, term()}
  def parse_file(path) do
    case File.read(path) do
      {:ok, content} -> parse_string(content)
      {:error, :enoent} -> {:error, :file_not_found}
      {:error, reason} -> {:error, reason}
    end
  end

  # --- Private helpers ---

  defp parse_comments(comment_lines) do
    Enum.reduce(comment_lines, %{}, fn line, acc ->
      case line do
        "#N " <> name -> Map.put(acc, :name, String.trim(name))
        "#N" <> name -> Map.put(acc, :name, String.trim(name))
        "#C " <> comment -> Map.update(acc, :comments, [comment], &(&1 ++ [comment]))
        "#c " <> comment -> Map.update(acc, :comments, [comment], &(&1 ++ [comment]))
        "#O " <> author -> Map.put(acc, :author, String.trim(author))
        _ -> acc
      end
    end)
  end

  defp parse_header(line) do
    trimmed = String.trim(line)

    case Regex.run(~r/x\s*=\s*(\d+)\s*,\s*y\s*=\s*(\d+)/, trimmed) do
      [_, x_str, y_str] ->
        {:ok, %{width: String.to_integer(x_str), height: String.to_integer(y_str)}}

      nil ->
        {:error, "invalid header: expected 'x = <width>, y = <height>', got: #{trimmed}"}
    end
  end

  defp decode_cells(data) do
    decode_cells(data, 0, 0, MapSet.new())
  end

  defp decode_cells("", _x, _y, cells), do: {:ok, cells}
  defp decode_cells("!" <> _rest, _x, _y, cells), do: {:ok, cells}

  defp decode_cells("$" <> rest, _x, y, cells) do
    decode_cells(rest, 0, y + 1, cells)
  end

  defp decode_cells(data, x, y, cells) do
    case Regex.run(~r/^(\d+)?([bo$])(.*)$/s, data) do
      [_, "", "o", rest] ->
        decode_cells(rest, x + 1, y, MapSet.put(cells, {x, y}))

      [_, count_str, "o", rest] ->
        count = String.to_integer(count_str)
        new_cells = Enum.reduce(0..(count - 1), cells, fn i, acc -> MapSet.put(acc, {x + i, y}) end)
        decode_cells(rest, x + count, y, new_cells)

      [_, "", "b", rest] ->
        decode_cells(rest, x + 1, y, cells)

      [_, count_str, "b", rest] ->
        count = String.to_integer(count_str)
        decode_cells(rest, x + count, y, cells)

      [_, "", "$", rest] ->
        decode_cells(rest, 0, y + 1, cells)

      [_, count_str, "$", rest] ->
        count = String.to_integer(count_str)
        decode_cells(rest, 0, y + count, cells)

      nil ->
        {:error, "unexpected character in RLE data near: #{String.slice(data, 0, 20)}"}
    end
  end
end
