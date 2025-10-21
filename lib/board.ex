defmodule Board do
  defstruct cells: [], prev_owner: %{}

  def new() do
    %Board{
      cells: [
      " ", " ", " "," ",
      " ", " ", " "," ",
      " ", " ", " "," ",
      " ", " ", " "," ",
    ]
  }
  end

  def play(%Board{cells: cells, prev_owner: prev} = board, %Player{symbol: symbol} = player, position) do
    current_symbol = Enum.at(cells, position) 

    cond do
      current_symbol == " " ->
        %Board{board | cells: List.replace_at(cells, position, symbol),
          prev_owner: Map.put(prev, position, symbol)}
      Map.get(prev, position, "") != symbol ->
        %Board{board | cells: List.replace_at(cells, position, symbol),
          prev_owner: Map.put(prev, position, symbol)}
      true ->
        board
    end

    #Map.replace(board, :cells, List.replace_at(board[:cells], position, player[:symbol]))
  end

end
