defmodule FizzTest do
  use ExUnit.Case

  @tag :pending
  test "null" do
    assert honk() == 4
  end

  def honk do
    2 + 1
  end
end
