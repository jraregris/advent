defmodule Day3Test do
  use ExUnit.Case

  test "parse claim id" do
    claim = Day3.parse("#123 @ 3,2: 5x4")
    assert claim.id == "123"
  end

  test "parse claim position" do
    claim = Day3.parse("#123 @ 3,2: 5x4")
    assert claim.position == {3, 2}
  end

  @tag :pending
  test "parse claim width" do
    claim = Day3.parse("#123 @ 3,2: 5x4")
    assert claim.width == 5
  end
end
