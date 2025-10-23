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
        previous_steal: %{}
      }
    end
  end

  describe "basic play" do
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

  describe "basic overwrite" do
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

    test "overwrite second player" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 2)
        |> Board.play(Player.new(:+, 3), 2)

      assert new_board.cells == [
        :x, :+, " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end
  end

  describe "tests for the revenge rules" do
    test "player2 overwrites player1 then player3 overwrites player2" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 1)


      assert new_board.cells == [
        :+, " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end

    test "player2 overwrites player1 then player1 cannot overwrite player2 on the same position" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 3)

      result = Board.play(new_board, Player.new(:x, 1), 1)

      assert result.cells == new_board.cells
    end

    test "player2 overwrites player1 then player1 cannot overwrite player2 on another position" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 2)
        |> Board.play(Player.new(:+, 3), 3)
        |> Board.play(Player.new(:x, 1), 4)
        |> Board.play(Player.new(:o, 2), 4)
        |> Board.play(Player.new(:+, 3), 5)

      assert new_board.previous_steal == %{
        :x => nil,
        :o => :x,
        :+ => nil,
      }

      result = Board.play(new_board, Player.new(:x, 1), 2)

      assert result.cells == new_board.cells
    end

    test "player2 overwrites 1 then player2 can overwrite player2 after another turn" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 2)
        |> Board.play(Player.new(:x, 1), 3)
        |> Board.play(Player.new(:o, 2), 4)
        |> Board.play(Player.new(:+, 3), 5)

      assert new_board.previous_steal == %{
        :x => nil,
        :o => nil,
        :+ => nil
      }

      result = Board.play(new_board, Player.new(:x, 1), 1)

      assert result.cells == [
        :x, :+, :x, :o,
        :+, " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end

    test "player2 overwrites 1 then player2 then player3 overwrites player2" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 1)

      assert new_board.previous_steal == %{
        :x => nil,
        :o => :x,
        :+ => :o
      }

      assert new_board.cells == [
        :+, " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ]
    end
  end
end
