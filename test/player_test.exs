defmodule PlayerTest do
  use ExUnit.Case

  test "greets the world" do
    assert Player.new(:x, 1) == %Player{symbol: :x, id: 1}
  end
end
