defmodule FizzTest do
  use ExUnit.Case

  test "null" do
    assert honk() == 4
  end

  def honk do
    4
  end
end
