defmodule Day3 do
  def parse(s) do
    [_, id, x] = Regex.run(~r/#(\d+) @ (\d+)/, s)

    %Claim{
      id: id,
      position: {x |> String.to_integer()}
    }
  end
end
