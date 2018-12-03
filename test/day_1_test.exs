defmodule AdventTest do
  use ExUnit.Case

  test "first example" do
    frequency = [+1, -2, +3, +1] |> Day1.calibrate()
    assert frequency == 3
  end

  test "second example" do
    frequency = [+1, +1, +1] |> Day1.calibrate()
    assert frequency == 3
  end
end
