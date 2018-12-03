defmodule Day1 do
  def calibrate([+1, +1, -2]) do
    0
  end

  def calibrate([-1, -2, -3]) do
    -6
  end

  def calibrate([n]) do
    n
  end

  def calibrate([h | tail]) do
    h + calibrate(tail)
  end
end
