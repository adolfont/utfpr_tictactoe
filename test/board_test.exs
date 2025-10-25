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
    test "Each player overwrite last one without revenge trigger" do
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

    test "Victim cannot retaliate against attacker" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 2)

      result = Board.play(new_board, Player.new(:x, 1), 1)

      assert result.cells == new_board.cells
    end

    test "Victim cannot retaliate anywhere, not just original position" do
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

    test "Crossposition revenge O steals from X, tries to steal again" do
      board = Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:x, 1), 2)

      result = Board.play(board, Player.new(:o, 2), 2)

      assert result.cells == board.cells
      assert Enum.at(result.cells, 1) == :x
    end

    test "Revenge can happen in some conditions" do
      # From README
      # X plays on (1,1)
      # O plays on (1,1)
      # + plays on (1,1)
      # X plays on (1,1)
      # O plays on (1,1)   ALLOWED
      # + plays on (2,2)
      # X plays on (1,1)   BLOCKED (X's last steal was from O at step 5)
      board = Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 1)
        |> Board.play(Player.new(:x, 1), 1)

      # Step 5: O plays (1,1)  ALLOWED
      board = Board.play(board, Player.new(:o, 2), 1)
      assert Enum.at(board.cells, 0) == :o, "Step 5: O successfully steals from X"

      # Step 6: + plays (2,2)
      board = Board.play(board, Player.new(:+, 3), 5)
      assert Enum.at(board.cells, 4) == :+

      # Step 7: X plays (1,1)  BLOCKED
      board_step7 = board
      board = Board.play(board, Player.new(:x, 1), 1)
      assert board.cells == board_step7.cells, "Step 7: X blocked (O just stole from X)"
      assert Enum.at(board.cells, 0) == :o
    end
  end
end
