defmodule BoardTest do
  use ExUnit.Case
  alias Board

  describe "new/0" do
    test "creates a new empty board" do
      assert Board.new() == %Board{
        cells: [
          " ", " ", " ", " ",
          " ", " ", " ", " ",
          " ", " ", " ", " ",
          " ", " ", " ", " "
        ],
        prev_owner: %{}
      }
    end
  end

  describe "play" do
    test "play once" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)

      assert new_board.cells == [
        :x, " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end
  end

  describe "overwrite" do
    test "overwrite first player" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)

      assert new_board.cells == [
        :o, " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end
  end

  describe "revenge" do
    test "player2 cannot overwrite player1 to his previous place" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 3)

      result = Board.play(new_board, Player.new(:x, 1), 1)

      assert result.cells == new_board.cells
    end
  end
end
