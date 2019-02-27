defmodule FizzTest do
  use ExUnit.Case

  @tag :pending
  test "null" do
    assert honk() == 3
  end

  def honk do
    2 + 1
  end
end
