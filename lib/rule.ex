defmodule Rule do
  def winning_board?([x, x, x, x, _, _, _, _, _, _, _, _, _, _, _, _]) when x != " ", do: true
  def winning_board?([_, _, _, _, x, x, x, x, _, _, _, _, _, _, _, _]) when x != " ", do: true
  def winning_board?([_, _, _, _, _, _, _, _, x, x, x, x, _, _, _, _]) when x != " ", do: true
  def winning_board?([_, _, _, _, _, _, _, _, _, _, _, _, x, x, x, x]) when x != " ", do: true
  def winning_board?([x, _, _, _, x, _, _, _, x, _, _, _, x, _, _, _]) when x != " ", do: true
  def winning_board?([_, x, _, _, _, x, _, _, _, x, _, _, _, x, _, _]) when x != " ", do: true
  def winning_board?([_, _, x, _, _, _, x, _, _, _, x, _, _, _, x, _]) when x != " ", do: true
  def winning_board?([_, _, _, x, _, _, _, x, _, _, _, x, _, _, _, x]) when x != " ", do: true
  def winning_board?([x, _, _, _, _, x, _, _, _, _, x, _, _, _, _, x]) when x != " ", do: true
  def winning_board?([_, _, _, x, _, _, x, _, _, x, _, _, x, _, _, _]) when x != " ", do: true
  def winning_board?(_), do: false
end
