defmodule Day3 do
  def parse(s) do
    [_, id, x, y, width] =
      Regex.run(
        ~r/#(\d+) @ (\d+),(\d+): (\d+)x/,
        s
      )

    %Claim{
      id: id,
      position:
        {x |> String.to_integer(),
         y |> String.to_integer()},
      size: {width}
    }
  end
end
