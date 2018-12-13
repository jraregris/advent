defmodule Day3 do
  def parse(s) do
    [_, id] = Regex.run(~r/#(\d+)/, s)
    %Claim{id: id}
  end
end
