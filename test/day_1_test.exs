defmodule Day1Test do
  use ExUnit.Case

  describe "calibration examples" do
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

  describe "calibration features" do
    test "one number" do
      frequency = [1] |> Day1.calibrate()
      assert frequency == 1
    end

    test "two numbers" do
      frequency = [1, 2] |> Day1.calibrate()
      assert frequency == 3
    end
  end

  describe "frequency examples" do
    test "first example" do
      frequency = [+1, -1] |> Day1.frequency()
      assert frequency == 0
    end

    test "second example" do
      frequency = [+3, +3, +4, -2, -4] |> Day1.frequency()
      assert frequency == 10
    end

    test "third example" do
      frequency = [-6, +3, +8, +5, -6] |> Day1.frequency()
      assert frequency == 5
    end

    @tag :pending
    test "fourth example" do
      frequency = [+7, +7, -2, -7, -4] |> Day1.frequency()
      assert frequency == 13
    end
  end
end
