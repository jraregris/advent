defmodule FizzTest do
  use ExUnit.Case

  test "null" do
    assert honk() == 3
  end

  def honk do
    2 + 1
  end
end
