defmodule Board do
  defstruct [:cells]

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

  def play(board, player, position) do
    %Board{board | cells: List.replace_at(board.cells, 0, player.symbol)}
    #Map.replace(board, :cells, List.replace_at(board[:cells], position, player[:symbol]))
  end

end
