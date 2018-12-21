defmodule TCR do
  def clear() do
    IO.ANSI.format([:clear, :home]) |> IO.write()
  end

  def test() do
    {_, status} = System.cmd("mix", ["test"])

    if(status == 0) do
      output(:ok, "Test OK")
    end

    case status do
      0 ->
        :ok

      _ ->
        :fail
    end
  end

  def commit() do
    {_, 0} = System.cmd("git", ["add", "."], into: "")

    commit_msg = "tcr"

    {output, status} = System.cmd("git", ["commit", "--message", commit_msg])

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, puts_error(error)}
    end
  end

  @messages [{~r/nothing to commit/, :nothing_to_commit}]

  defp puts_error(error) do
    error |> parse_error() |> format_msg() |> output()
  end

  defp parse_error(error) do
    {_, type} =
      Enum.find(
        @messages,
        fn {reg, _} ->
          String.match?(error, reg)
        end
      )

    type
  end

  defp format_msg(:nothing_to_commit), do: {:warning, "Nothing to commit"}

  defp output({type, msg}) do
    output(type, msg)
  end

  defp output(:warning, msg) do
    IO.ANSI.format([:yellow, msg]) |> IO.puts()
  end

  defp output(:ok, msg) do
    IO.ANSI.format([:green, msg]) |> IO.puts()
  end
end

TCR.clear()
test = TCR.test()

if test == :ok do
  TCR.commit()
end
