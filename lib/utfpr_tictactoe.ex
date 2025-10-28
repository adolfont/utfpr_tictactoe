defmodule UtfprTictactoe do
  def main() do
    IO.puts("\n=== Welcome to UTFPR Tic-Tac-Toe ===\n")
    IO.puts("Avaliable symbols: x, o, +\n")

    players = Player.setup_players()
    board = Board.new()

    IO.puts("\nPlayers:")
    IO.puts("Player 1: #{players.player1.symbol}")
    IO.puts("Player 2: #{players.player2.symbol}")
    IO.puts("Player 3: #{players.player3.symbol}")

    Board.display_board(board)

    game_loop(board, players, 1)
  end

  defp game_loop(_board, _players, _turn) do
    IO.puts("TODO: IMPLEMENT THE REST")
  end
end
