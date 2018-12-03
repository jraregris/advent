defmodule Day2 do
  def repeats(n) do
    groups =
      n
      |> String.graphemes()
      |> Enum.sort()
      |> Enum.chunk_by(fn x -> x end)
      |> Enum.map(fn x -> length(x) end)

    {groups |> Enum.member?(2), groups |> Enum.member?(3)}
  end

  def checksum(l) do
    {twi, thri} =
      Enum.reduce(l, {0, 0}, fn {twice?, thrice?}, {n_twice, n_thrice} ->
        twice = if twice?, do: n_twice + 1, else: n_twice
        thrice = if thrice?, do: n_thrice + 1, else: n_thrice
        {twice, thrice}
      end)

    twi * thri
  end
end
