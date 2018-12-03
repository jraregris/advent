defmodule AdventTest do
  use ExUnit.Case

  describe "Examples" do
    test "first example" do
      frequency = [+1, -2, +3, +1] |> Day1.calibrate()
      assert 3 == frequency
    end

    test "second example" do
      frequency = [+1, +1, +1] |> Day1.calibrate()
      assert 3 == frequency
    end

    test "third example" do
      frequency = [+1, +1, -2] |> Day1.calibrate()
      assert frequency == 0
    end

    test "fourth example" do
      frequency = [-1, -2, -3] |> Day1.calibrate()
      assert frequency == -6
    end
  end

  describe "features" do
    test "one number" do
    end
  end
end
