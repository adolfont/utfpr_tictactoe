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

end
