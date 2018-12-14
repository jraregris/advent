defmodule Day3 do
  def parse(s) do
    [_, id, x, y, width, height] =
      Regex.run(
        ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/,
        s
      )

    %Claim{
      id: id,
      position:
        {x |> String.to_integer(),
         y |> String.to_integer()},
      size:
        {width |> String.to_integer(),
         height |> String.to_integer()}
    }
  end
end
