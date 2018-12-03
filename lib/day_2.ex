defmodule Day2 do
  def repeats(n) do
    n
    |> String.graphemes()
    |> IO.inspect()

    {false, false}
  end
end
