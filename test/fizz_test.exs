defmodule FizzTest do
  use ExUnit.Case

  test "null" do
    assert honk() == 4
  end

  def honk do
    2 + 2
  end
end
