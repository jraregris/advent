defmodule Change do
  def start(n) do
    Agent.start_link(fn -> n end)
  end

  def next(f) do
    [h | tail] = Agent.get(f, fn n -> n end)
    Agent.update(f, fn _ -> tail ++ [h] end)
    h
  end
end
