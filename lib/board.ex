defmodule Board do
  defstruct cells: [], previous_steal: %{}

  def new() do
    %Board{
      cells: [
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " ",
        " ", " ", " ", " "
      ],
      previous_steal: %{}
    }
  end

  def play(
        %Board{cells: cells, previous_steal: previous_steal} = board,
        %Player{symbol: symbol},
        position
      ) do
    # off-by-one trap: user-facing positions start at 1, but Elixir list indexes start at 0,
    #                  so forgetting this misplaces every move what made tests fail.
    idx = position - 1

    # pass the position 0-index fix what we had problem in live
    current_symbol = Enum.at(cells, idx)
    previous_steal_current_symbol = Map.get(previous_steal, current_symbol)

    cond do
      current_symbol == " " ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            previous_steal: Map.put(previous_steal, symbol, nil)
        }

      # Check that no revenge is allowed against the last steal of the current symbol
      symbol != previous_steal_current_symbol ->
        %Board{
          board
          | cells: List.replace_at(cells, idx, symbol),
            previous_steal: Map.put(previous_steal, symbol, current_symbol)
        }

      true ->
        %Board{
          board
          | previous_steal: Map.put(previous_steal, symbol, nil)
        }
    end
  end
end
