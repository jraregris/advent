defmodule TCR do
  def clear() do
    IO.ANSI.format([:clear, :home]) |> IO.write()
  end

  def test() do
    IO.ANSI.format([:inverse, "TEST"]) |> IO.puts()

    {_, status} =
      System.cmd(
        "mix",
        ["test"],
        into: IO.stream(:stdio, 1)
      )

    case status do
      0 ->
        :ok

      _ ->
        :fail
    end
  end

  def commit() do
    IO.ANSI.format([:inverse, "COMMIT - ADD"]) |> IO.puts()

    {_, 0} = System.cmd("git", ["add", "."], into: "")

    IO.ANSI.format([:inverse, "COMMIT - COMMIT"]) |> IO.puts()

    {output, status} = System.cmd("git", ["commit", "--message", "tcr"])

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, puts_error(error)}
    end
  end

  @messages [{~r/nothing to commit/, :nothing_to_commit}]

  defp puts_error(error) do
    error |> parse_error |> format_error |> IO.puts()
  end

  defp parse_error(error) do
    {_, type} =
      Enum.find(
        @messages,
        fn {reg, type} ->
          String.match?(error, reg)
        end
      )

    type
  end

  defp format_error(:nothing_to_commit), do: "Nothing to commit"
end

TCR.clear()
test = TCR.test()

if test == :ok do
  TCR.commit() |> IO.inspect()
end
