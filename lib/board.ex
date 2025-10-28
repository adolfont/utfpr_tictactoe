defmodule Board do
  defstruct cells: [], previous_steal: %{}

  def new() do
    %Board{
      cells: [
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " ",
        " "
      ],
      previous_steal: %{}
    }
  end

  def play(
        %Board{cells: cells, previous_steal: previous_steal} = board,
        %Player{symbol: symbol},
        position
      ) do
    # off-by-one trap: user-facing positions start at 1, but Elixir list indexes start at 0,
    #                  so forgetting this misplaces every move what made tests fail.
    idx = position - 1

    # pass the position 0-index fix what we had problem in live
    current_symbol = Enum.at(cells, idx)

    my_last_steal = Map.get(previous_steal, symbol)
    their_last_steal = Map.get(previous_steal, current_symbol)

    cond do
      current_symbol == " " ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            previous_steal: Map.put(previous_steal, symbol, nil)
        }

      current_symbol == symbol ->
        board

      my_last_steal == current_symbol ->
        board

      their_last_steal == symbol ->
        board

      true ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            previous_steal:
              previous_steal
              |> Map.put(symbol, current_symbol)
              |> Map.put(current_symbol, nil)
        }
    end
  end

  defp convert_symbol_to_string(cell) do
    case cell do
      " " -> " "
      symbol -> Atom.to_string(symbol)
    end
  end

  def line_between(row_num) do
    if row_num < 4 do
      "\n ├───┼───┼───┼───┤"
    else
      "\n"
    end
  end

  def noname(data) do
    data
    |> Enum.map(fn {row, row_num} ->
      row_display =
        row
        |> Enum.map(&convert_symbol_to_string/1)
        |> Enum.join(" │ ")

      "#{row_num}│ #{row_display} │" <> line_between(row_num)
    end)
    |> Enum.join("\n")
  end

  def generate_inside_cells(cells) do
    cells
    |> Enum.chunk_every(4)
    |> Enum.with_index(1)
    |> noname()
  end

  def display_board(%Board{cells: cells}) do
    result = ""

    result = result <> "   1   2   3   4\n"
    result = result <> " ┌───┬───┬───┬───┐\n"

    result = result <> generate_inside_cells(cells)

    result = result <> " └───┴───┴───┴───┘\n"

    result
  end
end
