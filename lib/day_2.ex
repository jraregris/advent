defmodule Day2 do
  @spec repeats(binary()) ::
          {boolean(), boolean()}
  def repeats(n) do
    groups =
      n
      |> String.graphemes()
      |> Enum.sort()
      |> Enum.chunk_by(fn x -> x end)
      |> Enum.map(fn x -> length(x) end)

    {groups |> Enum.member?(2),
     groups |> Enum.member?(3)}
  end

  def checksum(l) when is_list(l) do
    l
    |> Enum.map(&repeats/1)
    |> Enum.reduce(
      {0, 0},
      fn {twice?, thrice?}, {n_twice, n_thrice} ->
        twice =
          if twice?,
            do: n_twice + 1,
            else: n_twice

        thrice =
          if thrice?,
            do: n_thrice + 1,
            else: n_thrice

        {twice, thrice}
      end
    )
    |> (fn {twi, thri} -> twi * thri end).()
  end

  def difference(a, b) do
    [a, b]
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.count(fn {a, b} -> a != b end)
  end

  def differ_by_one(list) do
    list
    |> permutations()
    |> Enum.find(fn {a, b} ->
      difference(a, b) == 1
    end)
  end

  def permutations(list) do
    for a <- list do
      for b <- list -- [a] do
        {a, b}
      end
    end
    |> Enum.concat()
    |> Enum.uniq_by(fn {a, b} ->
      [a, b] |> Enum.sort()
    end)
  end
end
