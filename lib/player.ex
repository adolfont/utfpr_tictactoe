defmodule Player do
  defstruct [:symbol, :id]

  @allowed_symbols [:x, :o, :+]

  def new(symbol, id) when symbol in @allowed_symbols do
    %Player{symbol: symbol, id: id}
  end

  def setup_players() do
    player1 = get_player_symbol("Player 1", [])
    player2 = get_player_symbol("Player 2", [player1.symbol])
    player3 = get_player_symbol("Player 3", [player1.symbol, player2.symbol])

    %{player1: player1, player2: player2, player3: player3}
  end

  def get_player_symbol(player_name, used_symbols) do
    symbol_str =
      IO.gets("#{player_name}, choose your symbol (x, o, +): ")
      |> String.trim()
      |> String.downcase()

    case parse_symbol(symbol_str) do
      {:ok, symbol} ->
        if symbol in used_symbols do
          IO.puts("Symbol already picked! Choose another\n")
          get_player_symbol(player_name, used_symbols)
        else
          player_id = length(used_symbols) + 1
          Player.new(symbol, player_id)
        end

      :error ->
        IO.puts("Invalid symbols! Avaliable: x, o, +\n")
        get_player_symbol(player_name, used_symbols)
    end
  end

  def parse_symbol("x"), do: {:ok, :x}
  def parse_symbol("o"), do: {:ok, :o}
  def parse_symbol("+"), do: {:ok, :+}
  def parse_symbol(_), do: :error
end
