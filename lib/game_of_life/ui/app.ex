defmodule GameOfLife.UI.App do
  @moduledoc """
  Ratatouille application for the Game of Life TUI.

  Implements the Elm-architecture callbacks: init/1, update/2, render/1,
  and subscribe/1.
  """

  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  alias GameOfLife.{Engine, Patterns}
  alias Ratatouille.Runtime.Subscription

  @default_speed 10
  @min_speed 1
  @max_speed 50
  @alive_char "█"

  @space_key key(:space)
  @arrow_up key(:arrow_up)
  @arrow_down key(:arrow_down)
  @enter_key key(:enter)

  @impl true
  def init(%{window: window} = context) do
    {cells, pattern_name} = load_initial_pattern()
    {vx, vy} = center_viewport(cells, window.width, window.height - 2)

    %{
      cells: cells,
      generation: 0,
      speed: @default_speed,
      paused: false,
      viewport_x: vx,
      viewport_y: vy,
      window_width: window.width,
      window_height: window.height,
      menu_open: false,
      menu_index: 0,
      pattern_name: pattern_name
    }
  end

  @impl true
  def update(model, msg) do
    case msg do
      {:event, %{key: @space_key}} ->
        %{model | paused: not model.paused}

      {:event, %{ch: ?n}} when model.paused and not model.menu_open ->
        %{model | cells: Engine.tick(model.cells), generation: model.generation + 1}

      {:event, %{ch: ?+}} when not model.menu_open ->
        %{model | speed: min(model.speed + 1, @max_speed)}

      {:event, %{ch: ?-}} when not model.menu_open ->
        %{model | speed: max(model.speed - 1, @min_speed)}

      {:event, %{ch: ?q}} when not model.menu_open ->
        {:quit, model}

      {:event, %{ch: ?l}} when not model.menu_open ->
        %{model | menu_open: true, menu_index: 0}

      {:event, %{key: 27}} when model.menu_open ->
        %{model | menu_open: false}

      {:event, %{key: @arrow_up}} when model.menu_open ->
        %{model | menu_index: max(model.menu_index - 1, 0)}

      {:event, %{key: @arrow_down}} when model.menu_open ->
        patterns = Patterns.list()
        %{model | menu_index: min(model.menu_index + 1, length(patterns) - 1)}

      {:event, %{key: @enter_key}} when model.menu_open ->
        select_pattern(model, model.menu_index)

      {:event, %{ch: ch}} when model.menu_open and ch in ?1..?9 ->
        index = ch - ?1
        patterns = Patterns.list()

        if index < length(patterns) do
          select_pattern(model, index)
        else
          model
        end

      :tick ->
        if model.paused do
          model
        else
          %{model | cells: Engine.tick(model.cells), generation: model.generation + 1}
        end

      _ ->
        model
    end
  end

  @impl true
  def subscribe(model) do
    # Ratatouille's runtime polls subscriptions on its own loop interval.
    # We compute the tick interval from the current speed.
    interval_ms = max(div(1000, model.speed), 20)
    Subscription.interval(interval_ms, :tick)
  end

  @impl true
  def render(model) do
    grid_height = model.window_height - 2

    grid_rows =
      for y <- 0..(grid_height - 1) do
        row_text =
          for x <- 0..(model.window_width - 1), into: "" do
            cell = {model.viewport_x + x, model.viewport_y + y}

            if MapSet.member?(model.cells, cell) do
              @alive_char
            else
              " "
            end
          end

        label(content: row_text)
      end

    status =
      if model.paused do
        "Gen: #{model.generation}  Alive: #{Engine.alive_count(model.cells)}  Speed: #{model.speed}/s  PAUSED"
      else
        "Gen: #{model.generation}  Alive: #{Engine.alive_count(model.cells)}  Speed: #{model.speed}/s"
      end

    controls = "Space: pause  n: step  +/-: speed  l: patterns  q: quit"

    status_bar =
      bar do
        label(content: status <> "  |  " <> controls)
      end

    menu_overlay =
      if model.menu_open do
        overlay do
          panel(title: "Load Pattern (up/down Enter / 1-9)", height: :fill) do
            for {pattern, i} <- Enum.with_index(Patterns.list()) do
              prefix = if i == model.menu_index, do: "> ", else: "  "
              label(content: "#{prefix}#{i + 1}. #{pattern.name}")
            end
          end
        end
      end

    children =
      [
        panel(title: "Game of Life - #{model.pattern_name}", height: :fill) do
          for row <- grid_rows do
            row
          end
        end
      ] ++ if(model.menu_open, do: [menu_overlay], else: [])

    view(bottom_bar: status_bar) do
      children
    end
  end

  # --- Private helpers ---

  defp load_initial_pattern do
    case Application.get_env(:game_of_life, :rle_file) do
      nil ->
        case Patterns.load("Glider") do
          {:ok, cells} -> {cells, "Glider"}
          {:error, _} -> {MapSet.new(), "Empty"}
        end

      path ->
        case GameOfLife.RLE.parse_file(path) do
          {:ok, %{cells: cells, metadata: meta}} ->
            name = Map.get(meta, :name, Path.basename(path, ".rle"))
            {cells, name}

          {:error, reason} ->
            IO.puts(:stderr, "Warning: failed to load #{path}: #{inspect(reason)}, using Glider")
            Application.delete_env(:game_of_life, :rle_file)
            load_initial_pattern()
        end
    end
  end

  defp center_viewport(cells, width, height) do
    if MapSet.size(cells) == 0 do
      {0, 0}
    else
      xs = Enum.map(cells, &elem(&1, 0))
      ys = Enum.map(cells, &elem(&1, 1))
      cx = div(Enum.min(xs) + Enum.max(xs), 2)
      cy = div(Enum.min(ys) + Enum.max(ys), 2)
      {cx - div(width, 2), cy - div(height, 2)}
    end
  end

  defp select_pattern(model, index) do
    patterns = Patterns.list()

    case Enum.at(patterns, index) do
      nil ->
        model

      %{name: name} ->
        case Patterns.load(name) do
          {:ok, cells} ->
            {vx, vy} = center_viewport(cells, model.window_width, model.window_height - 2)

            %{
              model
              | cells: cells,
                generation: 0,
                viewport_x: vx,
                viewport_y: vy,
                menu_open: false,
                pattern_name: name
            }

          {:error, _} ->
            %{model | menu_open: false}
        end
    end
  end
end
