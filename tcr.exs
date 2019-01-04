defmodule TCR do
  def clear() do
    IO.ANSI.format([:clear, :home]) |> IO.write()
    IO.ANSI.format([:light_black, DateTime.utc_now() |> to_string]) |> IO.puts()
  end

  def test(verbose: verbose) do
    {cmd_output, status} =
      System.cmd("mix", ["test", "--exclude", "pending", "--color"])

    if(status == 0) do
      if(verbose > 0) do
        IO.puts(cmd_output)
      end

      output(:ok, "Test OK")
      :ok
    else
      IO.puts(cmd_output)
      :fail
    end
  end

  def commit(commit_msg) when is_binary(commit_msg) do
    {_, 0} = System.cmd("git", ["add", "."], into: "")

    {output, status} =
      System.cmd(
        "git",
        ["commit", "--message", commit_msg],
        stderr_to_stdout: true
      )

    if(status == 0) do
      IO.puts("Commit: " <> commit_msg)
    end

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, puts_error(error)}
    end
  end

  def revert() do
    {_, 0} = System.cmd("git", ["reset", "--hard"])
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

  def tcr(commit_msg: commit_msg, verbose: verbose) do
    TCR.clear()
    test = TCR.test(verbose: verbose)

    if test == :ok do
      TCR.commit(commit_msg)
    end

    if test == :fail do
      TCR.revert()
    end

    TCR.pending()

    choice =
      [
        :blue,
        commit_msg,
        :reset,
        " Again?",
        :light_black,
        " (m for new msg) ",
        :reset,
        "Y/n? "
      ]
      |> IO.ANSI.format()
      |> IO.gets()

    yeses = ["\n", "y\n", "Y\n", "yes\n"]
    message = ["m\n", "M\n"]

    cond do
      choice in yeses ->
        TCR.tcr(commit_msg: commit_msg, verbose: verbose)

      choice in message ->
        TCR.tcr(commit_msg: get_commit_msg(), verbose: verbose)

      true ->
        nil
    end
  end

  defp get_commit_msg() do
    IO.gets("Next commit msg: ") |> String.trim()
  end
end

{opts, whatever, _} =
  OptionParser.parse(
    System.argv(),
    aliases: [v: :verbose, m: :message],
    switches: [verbose: :count, message: :string]
  )

commit_msg = opts[:message] || Enum.join(whatever, " ")
verbose = opts[:verbose] || 0

TCR.tcr(commit_msg: commit_msg, verbose: verbose)
