defmodule Term do
  def clear() do
    IO.ANSI.format([:clear, :home])
    |> IO.write()
  end

  def timestamp do
    t = DateTime.utc_now()

    IO.ANSI.format([:light_black, t |> to_string])
    |> IO.write()

    t
  end

  def timestamp_done(start_time) do
    duration =
      DateTime.utc_now()
      |> DateTime.diff(start_time, :milliseconds)

    IO.ANSI.format([" ", duration |> to_string, "ms"])
    |> IO.write()
  end

  def status(:ok) do
    [" ", :green_background, :black, " Test OK "]
    |> IO.ANSI.format()
    |> IO.write()
  end

  def gets(msg) do
    IO.gets(msg)
    |> String.trim()
  end

  def puts(msg) do
    msg |> IO.puts()
  end

  def puts(msg, color) do
    IO.ANSI.format([color, msg])
    |> IO.write()
  end

  def warn(msg) do
    puts(msg, :yellow)
  end

  def error(msg) do
    puts(msg, :red)
  end

  def ok(msg) do
    puts(msg, :green)
  end

  def choice(msg) do
    msg
    |> IO.gets()
    |> String.trim()
    |> String.downcase()
    |> case do
      "n" ->
        :no

      "m" ->
        :message

      _ ->
        :yes
    end
  end
end

defmodule TCR do
  def test(verbose: verbose) do
    {cmd_output, status} =
      System.cmd("mix", ["test", "--exclude", "pending", "--color"])

    if(status == 0) do
      if(verbose > 0) do
        Term.puts(cmd_output)
      end

      :ok
    else
      Term.puts(cmd_output)
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
      Term.puts("Commit: " <> commit_msg)
    end

    case {output, status} do
      {_, 0} -> :ok
      {error, 1} -> {:error, puts_error(error)}
    end
  end

  def revert() do
    {_, 0} = System.cmd("git", ["reset", "--hard"])
    Term.error("Reverting HARD!")
  end

  def pending() do
    {_, status} = System.cmd("grep", ["--recursive", "@tag :pending", "test"])

    if status == 0 do
      {output, status} =
        System.cmd("mix", ["test", "--only", "pending", "--color"])

      if(status == 0) do
        Term.ok("Pending test OK, remove pending tag!")
      else
        Term.warn("\nPending test(s):")
        Term.puts(output)
      end
    end
  end

  defp puts_error(error) do
    cond do
      Regex.match?(~r/nothing to commit/, error) ->
        Term.warn("Nothing to commit")

      true ->
        Term.puts(error)
    end
  end

  def tcr(commit_msg: commit_msg, verbose: verbose) do
    Term.clear()
    t = Term.timestamp()

    test = TCR.test(verbose: verbose)

    Term.timestamp_done(t)

    if test == :ok do
      Term.status(:ok)
      TCR.commit(commit_msg)
    end

    if test == :fail do
      TCR.revert()
    end

    TCR.pending()

    prompt(commit_msg)
    |> case do
      :yes ->
        TCR.tcr(commit_msg: commit_msg, verbose: verbose)

      :message ->
        TCR.tcr(commit_msg: get_commit_msg(), verbose: verbose)

      _ ->
        nil
    end
  end

  defp prompt(commit_msg) do
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
    |> Term.choice()
  end

  defp get_commit_msg() do
    Term.gets("Next commit message: ")
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
