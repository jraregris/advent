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

    test "checksum2" do
      checksum = ["abcdefgg", "abbcdeee"] |> Day2.checksum()
      assert checksum == 2
    end

    test "checksum2 example" do
      checksum =
        [
          "abcdef",
          "bababc",
          "abbcde",
          "abcccd",
          "aabcdd",
          "abcdee",
          "ababab"
        ]
        |> Day2.checksum()

      assert checksum == 12
    end

    @tag :pending
    test "difference" do
    end
  end
end
