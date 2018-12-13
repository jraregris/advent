defmodule Day3 do
  def parse(s) do
    [_, id, x, y] =
      Regex.run(~r/#(\d+) @ (\d+),(\d+)/, s)

    %Claim{
      id: id,
      position:
        {x |> String.to_integer(),
         y |> String.to_integer()}
    }
  end
end
