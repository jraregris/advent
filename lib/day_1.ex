defmodule Day1 do
  def calibrate([]) do
    0
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end

  def frequency(n) do
    {:ok, frequencies} = Freqs.start()
    {:ok, changes} = Change.start(n)

    go_nuts(changes, frequencies, 0)
  end

  def go_nuts(changes, frequencies, sum) do
    next_change = changes |> Change.next()
    new_sum = sum + next_change

    frequencies
    |> Freqs.has?(new_sum)
    |> case do
      true ->
        new_sum

      false ->
        frequencies |> Freqs.add(new_sum)
        go_nuts(changes, frequencies, new_sum)
    end
  end
end
