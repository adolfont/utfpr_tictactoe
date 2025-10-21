defmodule Board do
  defstruct cells: [], prev_owner: %{}

  def new() do
    %Board{
      cells: [
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ],
      prev_owner: %{}
    }
  end

  def play(%Board{cells: cells, prev_owner: prev} = board, %Player{symbol: symbol}, position) do
    # off-by-one trap: user-facing positions start at 1, but Elixir list indexes start at 0, 
    #                  so forgetting this misplaces every move what made tests fail.
    idx = position - 1

    # pass the position 0-index fix what we had problem in live
    current_symbol = Enum.at(cells, idx)
    previous_symbol = Map.get(prev, idx)

    cond do
      current_symbol == " " ->
        %Board{board | cells: List.replace_at(cells, idx, symbol)}
      previous_symbol != symbol and current_symbol != symbol ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            prev_owner: Map.put(prev, idx, current_symbol)
        }
      true ->
        board
    end

    #Map.replace(board, :cells, List.replace_at(board[:cells], position, player[:symbol]))

  end
end
