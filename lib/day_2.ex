defmodule Day2 do
  def repeats(n) do
    n
    |> String.graphemes()
    |> Enum.sort()
    |> IO.inspect()

    {false, false}
  end
end
