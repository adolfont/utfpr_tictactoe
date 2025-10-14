defmodule Board do
  defstruct [:cells]

  def new() do
    %Board{
      cells: [
      " ", " ", " "," ",
      " ", " ", " "," ",
      " ", " ", " "," ",
      " ", " ", " "," ",
    ]
  }
  end

end
