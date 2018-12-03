defmodule Day1 do
  def calibrate([n]) do
    n
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end

  def frequency(n) do
    {:ok, frequencies} = Freqs.start()
    {:ok, changes} = Change.start(n)

    0
  end
end
