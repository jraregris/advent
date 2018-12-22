defmodule TCR do
  def clear() do
    IO.ANSI.format([:clear, :home]) |> IO.write()
    IO.ANSI.format([:light_black, DateTime.utc_now() |> to_string]) |> IO.puts()
  end

  def test() do
    {cmd_output, status} =
      System.cmd("mix", ["test", "--exclude", "pending", "--color"])

    if(status == 0) do
      output(:ok, "Test OK")
      :ok
    else
      IO.puts(cmd_output)
      :fail
    end
  end

  def commit() do
    {_, 0} = System.cmd("git", ["add", "."], into: "")

    {output, status} = System.cmd("git", ["commit", "--message", commit_msg()])

    if(status == 0) do
      IO.puts("Commit: " <> commit_msg)
    end

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, puts_error(error)}
    end
  end

  defp commit_msg() do
    System.argv() |> Enum.join()
  end

  def revert() do
    {output, status} = System.cmd("git", ["reset", "--hard"])
    output(:error, "Reverting HARD!")
  end

  def pending() do
    {_, status} = System.cmd("grep", ["--recursive", "@tag :pending", "test"])

    if status == 0 do
      {output, status} =
        System.cmd("mix", ["test", "--only", "pending", "--color"])

      if(status == 0) do
        output(:ok, "Pending test OK, remove pending tag!")
      else
        output(:warning, "\nPending test(s):")
        IO.puts(output)
      end
    end
  end

  defp puts_error(error) do
    cond do
      Regex.match?(~r/nothing to commit/, error) ->
        output(:warning, "Nothing to commit")

      true ->
        IO.puts(error)
    end
  end

  defp output(:warning, msg) do
    IO.ANSI.format([:yellow, msg]) |> IO.puts()
  end

  defp output(:ok, msg) do
    IO.ANSI.format([:green, msg]) |> IO.puts()
  end

  defp output(:error, msg) do
    IO.ANSI.format([:red, msg]) |> IO.puts()
  end

  def tcr() do
    TCR.clear()
    test = TCR.test()

    if test == :ok do
      TCR.commit()
    end

    if test == :fail do
      TCR.revert()
    end

    TCR.pending()

    choice = IO.gets("Again? Y/n? ")

    yeses = ["\n", "y\n", "Y\n", "yes\n"]

    cond do
      choice in yeses -> TCR.tcr()
      true -> nil
    end
  end
end

TCR.tcr()
