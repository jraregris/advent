defmodule Day1 do
  def calibrate([n]) do
    n
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end
end
