defmodule Day2Test do
  use ExUnit.Case

  describe "features" do
    test "no repeats" do
      repeats = "abcdef" |> Day2.repeats()
      assert repeats == {false, false}
    end

    test "repeat twice" do
      repeats = "abcdee" |> Day2.repeats()
      assert repeats == {true, false}
    end

    test "repeat trice" do
      repeats = "abcccd" |> Day2.repeats()
      assert repeats == {false, true}
    end

    test "checksum" do
      checksum = [{false, true}, {true, true}] |> Day2.checksum()
    end
  end
end
