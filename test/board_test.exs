defmodule BoardTest do
  use ExUnit.Case
  alias Board

  describe "new/0" do
    test "creates a new empty board" do
      assert Board.new() == %Board{
               cells: List.duplicate(" ", 16),
               cell_history: %{},
               last_steal: %{}
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
    test "Chain of steals without revenge triggering" do
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

    test "Cell-based revenge: victim cannot retake same position" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 2)

      # X tries to steal from O at position 1 where O just stole from X
      result = Board.play(new_board, Player.new(:x, 1), 1)

      assert result.cells == new_board.cells, "X blocked by cell revenge at position 1"
      assert Enum.at(result.cells, 0) == :o
    end

    test "Cross-revenge: attacker cannot steal from same victim twice" do
      board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)  # O steals from X
        |> Board.play(Player.new(:x, 1), 2)  # X plays elsewhere

      # O tries to steal from X again at position 2
      result = Board.play(board, Player.new(:o, 2), 2)

      assert result.cells == board.cells, "O blocked: cannot steal from X twice in a row"
      assert Enum.at(result.cells, 1) == :x
    end

    test "Cell-based revenge: victim blocked at specific position only" do
      board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)  # O steals from X at pos 1
        |> Board.play(Player.new(:+, 3), 3)

      # X tries to retake position 1 - blocked by cell revenge
      result = Board.play(board, Player.new(:x, 1), 1)

      assert result.cells == board.cells, "X blocked by cell revenge at position 1"
      assert Enum.at(result.cells, 0) == :o
    end

    test "README example: complex revenge scenario" do
      #1: X plays on (1,1)
      #2: O plays on (1,1)
      #3: + plays on (1,1)
      #4: X plays on (1,1)
      #5: O plays on (1,1)   BLOCKED, not by cell rule, but by cross rule
      #6: + plays on (2,2)
      #7: X plays on (1,1)   BLOCKED (X's last steal was from O at step 5)

      # Step 1-4: Setup
      board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)
        |> Board.play(Player.new(:+, 3), 1)
        |> Board.play(Player.new(:x, 1), 1)

      # Step 5: O tries to play at (1,1)
      # This should be BLOCKED because O's last_steal is :x
      board_before = board
      board = Board.play(board, Player.new(:o, 2), 1)

      assert board.cells == board_before.cells, "Step 5: O blocked by cross-revenge"
      assert Enum.at(board.cells, 0) == :x

      # Step 6: + plays on (2,2)
      board = Board.play(board, Player.new(:+, 3), 5)
      assert Enum.at(board.cells, 4) == :+

      # Step 7: X tries to play at (1,1) - blocked by own symbol
      board_step7 = board
      board = Board.play(board, Player.new(:x, 1), 1)
      assert board.cells == board_step7.cells, "Step 7: X blocked (own symbol)"
      assert Enum.at(board.cells, 0) == :x
    end

    test "History persistence: trackers accumulate and persist correctly" do
      board =
        Board.new()
        # Position 1: X plays empty
        |> Board.play(Player.new(:x, 1), 1)

      assert board.cell_history == %{}
      assert board.last_steal == %{:x => nil}

      # Position 1: O steals from X
      board = Board.play(board, Player.new(:o, 2), 1)

      assert board.cell_history == %{0 => {:o, :x}}
      assert board.last_steal == %{:x => nil, :o => :x}

      # Position 5: + plays empty
      board = Board.play(board, Player.new(:+, 3), 5)

      assert board.cell_history == %{0 => {:o, :x}}, "Cell history at pos 1 persists"
      assert board.last_steal == %{:x => nil, :o => :x, :+ => nil}

      # Position 10: X plays empty
      board = Board.play(board, Player.new(:x, 1), 10)

      assert board.cell_history == %{0 => {:o, :x}}, "Cell history still persists"
      assert board.last_steal == %{:x => nil, :o => :x, :+ => nil}

      # Position 5: O steals from +
      board = Board.play(board, Player.new(:o, 2), 5)

      assert board.cell_history == %{
        0 => {:o, :x},    # Position 1 history preserved
        4 => {:o, :+}     # Position 5 history added
      }
      assert board.last_steal == %{:x => nil, :o => :+, :+ => nil}

      # Position 1: X tries to steal from O - BLOCKED by cell revenge
      board_before = board
      board = Board.play(board, Player.new(:x, 1), 1)

      assert board == board_before, "X blocked by cell revenge (O stole from X at pos 1)"
      assert board.cell_history == %{
        0 => {:o, :x},
        4 => {:o, :+}
      }, "History unchanged after blocked move"

      # Position 10: O steals from X
      board = Board.play(board, Player.new(:o, 2), 10)

      assert board.cell_history == %{
        0 => {:o, :x},    # Position 1 still preserved
        4 => {:o, :+},    # Position 5 still preserved
        9 => {:o, :x}     # Position 10 added
      }, "All cell histories accumulate, none are reset"

      assert board.last_steal == %{:x => nil, :o => :x, :+ => nil}

      # Final verification: all history intact
      assert map_size(board.cell_history) == 3, "Three positions have steal history"
      assert board.cell_history[0] == {:o, :x}, "Position 1 history intact"
      assert board.cell_history[4] == {:o, :+}, "Position 5 history intact"
      assert board.cell_history[9] == {:o, :x}, "Position 10 history intact"
    end

    test "Steal tracking across multiple positions" do
      new_board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 2)
        |> Board.play(Player.new(:+, 3), 6)
        |> Board.play(Player.new(:x, 1), 6)
        |> Board.play(Player.new(:o, 2), 6)

      expected = %Board{
        cells: [
          :x, :o, " ", " ",
          " ", :o, " ", " ",
          " ", " ", " ", " ",
          " ", " ", " ", " "
        ],
        cell_history: %{5 => {:o, :x}},
        last_steal: %{:+ => nil, :x => :+, :o => :x}
      }

      assert new_board == expected
    end

    test "Cell revenge persists even after other moves" do
      board =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 1)  # O steals from X at pos 1
        |> Board.play(Player.new(:+, 3), 3)
        |> Board.play(Player.new(:x, 1), 4)
        |> Board.play(Player.new(:o, 2), 5)

      # X tries to retake position 1 - still blocked by cell revenge
      result = Board.play(board, Player.new(:x, 1), 1)

      assert result.cells == board.cells, "X still blocked by cell revenge at position 1"
      assert Enum.at(result.cells, 0) == :o
    end
  end

  # REPL DRIVEN DEVELOPMENT

  # IEX IS A REPL
  # READ
  # EVAL
  # PRINT
  # LOOP

  describe "tests for board display" do
    test "Correctly displays the board after three moves" do
      string_containing_board_after_moves =
        Board.new()
        |> Board.play(Player.new(:x, 1), 1)
        |> Board.play(Player.new(:o, 2), 2)
        |> Board.play(Player.new(:+, 3), 5)
        |> Board.display_board()

      assert string_containing_board_after_moves ==
               """
                  1   2   3   4
                ┌───┬───┬───┬───┐
               1│ x │ o │   │   │
                ├───┼───┼───┼───┤
               2│ + │   │   │   │
                ├───┼───┼───┼───┤
               3│   │   │   │   │
                ├───┼───┼───┼───┤
               4│   │   │   │   │
                └───┴───┴───┴───┘
               """
    end
  end
end
