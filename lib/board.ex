defmodule Board do
  defstruct cells: [], cell_history: %{}, last_steal: %{}

  def new() do
    %Board{
      cells: [
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ],
      cell_history: %{},
      last_steal: %{}
    }
  end

  def play(
        %Board{cells: cells, cell_history: cell_history, last_steal: last_steal} = board,
        %Player{symbol: symbol},
        position
      ) do

    idx = position - 1
    current_symbol = Enum.at(cells, idx)

    last_steal_at_cell = Map.get(cell_history, idx)
    my_last_steal = Map.get(last_steal, symbol)

    cond do
      current_symbol == " " ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            last_steal: Map.put(last_steal, symbol, nil)
        }

      current_symbol == symbol ->
        board

      last_steal_at_cell == {current_symbol, symbol} ->
        board

      my_last_steal == current_symbol ->
        board

      true ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            cell_history: Map.put(cell_history, idx, {symbol, current_symbol}),
            last_steal: Map.put(last_steal, symbol, current_symbol)
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

  def display_inside_cells(data) do
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
    |> display_inside_cells()
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
