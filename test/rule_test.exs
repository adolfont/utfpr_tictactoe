defmodule RuleTest do
  use ExUnit.Case

  @player_x Player.new(:x, 1)
  @player_o Player.new(:o, 2)
  @player_plus Player.new(:+, 3)

  describe "winning_board?/1" do
    test "board horizontal win - first row" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_x, 4)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board horizontal win - second row" do
      board =
        Board.new()
        |> Board.play(@player_o, 5)
        |> Board.play(@player_o, 6)
        |> Board.play(@player_o, 7)
        |> Board.play(@player_o, 8)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board horizontal win - third row" do
      board =
        Board.new()
        |> Board.play(@player_x, 9)
        |> Board.play(@player_x, 10)
        |> Board.play(@player_x, 11)
        |> Board.play(@player_x, 12)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board horizontal win - fourth row" do
      board =
        Board.new()
        |> Board.play(@player_o, 13)
        |> Board.play(@player_o, 14)
        |> Board.play(@player_o, 15)
        |> Board.play(@player_o, 16)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board vertical win - first column" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 5)
        |> Board.play(@player_x, 9)
        |> Board.play(@player_x, 13)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board vertical win - second column" do
      board =
        Board.new()
        |> Board.play(@player_o, 2)
        |> Board.play(@player_o, 6)
        |> Board.play(@player_o, 10)
        |> Board.play(@player_o, 14)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board vertical win - third column" do
      board =
        Board.new()
        |> Board.play(@player_x, 3)
        |> Board.play(@player_x, 7)
        |> Board.play(@player_x, 11)
        |> Board.play(@player_x, 15)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board vertical win - fourth column" do
      board =
        Board.new()
        |> Board.play(@player_o, 4)
        |> Board.play(@player_o, 8)
        |> Board.play(@player_o, 12)
        |> Board.play(@player_o, 16)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board diagonal win - main diagonal" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 6)
        |> Board.play(@player_x, 11)
        |> Board.play(@player_x, 16)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board diagonal win - anti-diagonal" do
      board =
        Board.new()
        |> Board.play(@player_o, 4)
        |> Board.play(@player_o, 7)
        |> Board.play(@player_o, 10)
        |> Board.play(@player_o, 13)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board win with overwrites - same symbol" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_o, 5)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_o, 6)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_o, 7)
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 4)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board win with stealing mechanics" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_o, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_o, 4)
        |> Board.play(@player_x, 5)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_x, 6)
        |> Board.play(@player_x, 7)

      board = Board.play(board, @player_x, 8)

      assert Rule.winning_board?(board.cells) == true
    end

    test "board with no win - empty board" do
      board = Board.new()
      assert Rule.winning_board?(board.cells) == false
    end

    test "board with no win - partial game" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_o, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_o, 5)
        |> Board.play(@player_x, 6)
        |> Board.play(@player_o, 7)
        |> Board.play(@player_x, 9)
        |> Board.play(@player_o, 10)
        |> Board.play(@player_x, 11)

      assert Rule.winning_board?(board.cells) == false
    end

    test "board with no win - almost horizontal" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_o, 4)

      assert Rule.winning_board?(board.cells) == false
    end

    test "board with no win - almost vertical" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 5)
        |> Board.play(@player_x, 9)
        |> Board.play(@player_o, 13)

      assert Rule.winning_board?(board.cells) == false
    end

    test "board with no win - almost diagonal" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 6)
        |> Board.play(@player_x, 11)
        |> Board.play(@player_o, 16)

      assert Rule.winning_board?(board.cells) == false
    end

    test "complex board with mixed symbols but winning pattern" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_o, 2)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_plus, 4)
        |> Board.play(@player_x, 4)
        |> Board.play(@player_x, 4)

      assert Rule.winning_board?(board.cells) == true
    end

    test "overwrite maintains win condition" do
      board =
        Board.new()
        |> Board.play(@player_x, 1)
        |> Board.play(@player_x, 2)
        |> Board.play(@player_x, 3)
        |> Board.play(@player_x, 4)

      assert Rule.winning_board?(board.cells) == true

      board = Board.play(board, @player_x, 1)

      assert Rule.winning_board?(board.cells) == true
    end
  end
end
