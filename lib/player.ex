defmodule Player do
  defstruct [:symbol, :id]

  @allowed_symbols [:x, :o, :+]

  def new(symbol, id) when symbol in @allowed_symbols do
    %Player{symbol: symbol, id: id}
  end
end
