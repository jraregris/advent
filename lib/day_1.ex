defmodule Day1 do
  def calibrate([n]) do
    n
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end

  def frequency(n) do
    Stream.cycle(n) |> IO.inspect()
    0
  end
end
