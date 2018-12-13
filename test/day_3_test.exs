defmodule Day3Test do
  use ExUnit.Case

  @tag :pending
  test "parse claim id" do
    claim = Day3.parse("#123 @ 3,2: 5x4")
    assert claim.id == 123
  end
end
