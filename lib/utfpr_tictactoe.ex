defmodule UtfprTictactoe do
  
  def start_game() do
    player1_symbol = IO.gets("Player 1 symbol: ") |> String.trim()
    player1 = Player.new(player1_symbol, 1)
    
    player2_symbol = IO.gets("Player 2 symbol: ") |> String.trim()
    player2 = Player.new(player2_symbol, 2)

    player3_symbol = IO.gets("Player 3 symbol: ") |> String.trim()
    player3 = Player.new(player3_symbol, 3)

    board = Board.new()
  end

end

UtfprTictactoe.start_game()
