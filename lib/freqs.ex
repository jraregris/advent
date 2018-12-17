defmodule Freqs do
  @spec start() :: {:error, any()} | {:ok, pid()}
  def start do
    Agent.start_link(fn -> MapSet.new([0]) end)
  end

  @spec add(pid(), number()) :: :ok
  def add(f, n) when is_pid(f) and is_number(n) do
    Agent.update(f, fn freqs ->
      MapSet.put(freqs, n)
    end)
  end

  @spec has?(pid(), number()) :: any()
  def has?(f, n)
      when is_pid(f) and is_number(n) do
    Agent.get(f, fn freqs ->
      MapSet.member?(freqs, n)
    end)
  end
end
