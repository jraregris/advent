defmodule AdventTest do
  use ExUnit.Case

  test "greets the world" do
    frequency = [+1, -2, +3, +1] |> Day1.calibrate()
    assert frequency == 3
  end
end
