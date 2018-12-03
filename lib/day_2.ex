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
  end
end
