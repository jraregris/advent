defmodule Freqs do
  def start do
    Agent.start_link(fn -> MapSet.new([0]) end)
  end

  def add(f, n) do
    Agent.update(f, fn freqs ->
      MapSet.put(freqs, n)
    end)
  end

  def has?(f, n) do
    Agent.get(f, fn freqs ->
      MapSet.member?(freqs, n)
    end)
  end
end
