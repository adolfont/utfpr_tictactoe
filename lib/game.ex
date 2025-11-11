defmodule Game do
  def main(_args) do
    IO.puts("This is UTFPR Tic-Tac-Toe!\n")

    IO.puts("There are three players and the order is 'X', 'O', '+'!\n")

    b = Board.new()

    play([:x, :o, :+], b)
  end

  defp play(players, board) do
    [current_player | rest] = players

    IO.puts("Current board")
    IO.puts(Board.display_board(board))

    IO.puts("In what position (line, column) do you want to play, player #{current_player}?")
    {line, column} = process_input_string(IO.gets("Choose between (1,1) and (4,4): "))

    if line in 1..4 and column in 1..4 do
      new_board = Board.play(board, Player.new(current_player, 999), (line - 1) * 4 + column)
      play(rest ++ [current_player], new_board)
    else
      IO.puts("Wrong position!")
      play(players, board)
    end
  end

  defp process_input_string(a_string) do
    if Regex.match?(~r/\(\d,\d\)/, a_string) do
      x =
        a_string
        |> String.at(1)
        |> String.to_integer()

      y =
        a_string
        |> String.at(3)
        |> String.to_integer()

      {x, y}
    else
      {-1, -1}
    end
  end
end
