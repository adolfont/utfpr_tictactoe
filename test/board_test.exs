defmodule BoardTest do
	use ExUnit.Case
	alias Board

  describe "new/0" do
    test "creates a new empty board" do
      assert Board.new() == %Board{
        cells: [
        " ", " ", " "," ",
        " ", " ", " "," ",
        " ", " ", " "," ",
        " ", " ", " "," ",
      ]
    }
    end
  end

  describe "play" do
    test "play once" do
      new_board = Board.new()
        |> Board.play(Player.new(:x, 1), 1)

      assert new_board == %Board{
        cells: [
        :x, " ", " "," ",
        " ", " ", " "," ",
        " ", " ", " "," ",
        " ", " ", " "," ",
      ]
    }
    end
  end

end
