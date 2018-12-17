defmodule Day1 do
  @spec calibrate([number()]) :: number()
  def calibrate([]) do
    0
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end

  @spec frequency([number()]) :: number()
  def frequency(n) when is_list(n) do
    {:ok, frequencies} = Freqs.start()
    {:ok, changes} = Change.start(n)

    go_nuts(changes, frequencies, 0)
  end

  @spec go_nuts(pid(), pid(), number()) ::
          number()
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
