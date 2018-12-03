defmodule Day2Test do
  use ExUnit.Case

  describe "features" do
    test "no repeats" do
      repeats = "abcdef" |> Day2.repeats()
      assert repeats == 0
    end

    test "repeat twice" do
      repeats = "abcdef" |> Day2.repeats()
      assert repeats == 0
    end
  end
end
